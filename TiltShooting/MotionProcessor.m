//
//  MotionProcessor.m
//  TiltShooting
//
//  Created by yirui zhang on 9/26/12.
//
//

#import "MotionProcessor.h"
#import "ModelUtilities.h"
#import "Model.h"
#import "Aim.h"
#import <CoreMotion/CoreMotion.h>
#define DEFAULT_INTERVAL (1/100.f)
@interface MotionProcessor()
@property (strong) CMMotionManager *motionManager;
@property (strong) CMAttitude *referenceAttitude;
@property (weak) NSTimer *timer;
@property NSUInteger runningTimes;
@property NSTimeInterval lastTime;

- (void) run: (NSTimer *)timer;
- (CMAcceleration) computeGrivaty: (CMRotationMatrix)rotationMatrix;
@end

@implementation MotionProcessor
@synthesize motionManager = _motionManager;
@synthesize timer = _timer;
@synthesize referenceAttitude = _referenceAttitude;
@synthesize flushInterval = _flushInterval;
@synthesize runningTimes = _runningTimes;
@synthesize lastTime = _lastTime;

- (id) init {
    if (self = [super init]) {
        self.flushInterval = DEFAULT_INTERVAL;
        self.runningTimes = 0;
        self.lastTime = -1.0;
        // start listening to motion events
        if (self.motionManager == nil) {
            self.motionManager = [[CMMotionManager alloc] init];
        }
        // detect if the device support motion
        if (![self.motionManager isDeviceMotionAvailable]) {
            [NSException raise:@"Motion is not supported"
                        format:@"The device doesn't support motion, must be iphone 4 or later."];
        }
        // init motion interval
        self.motionManager.accelerometerUpdateInterval = 0.01;
    }
    return self;
}

- (void) start {
    // start listening motion events
    [self.motionManager startDeviceMotionUpdates];
    [self resume];
    NSLog(@"Motion Processor Start");
}

- (void) resume {
    // cancel a pre-existing timer.
    [self.timer invalidate];
    // init. new timer
    NSTimer *timer = [NSTimer timerWithTimeInterval:self.flushInterval
                                                      target:self
                                                    selector:@selector(runAsync:)
                                                    userInfo:nil
                                                     repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    self.timer = timer;
    NSLog(@"Motion Processor Resume");
}

- (void) pause {
    [self.timer invalidate];
    self.referenceAttitude = nil;
    self.lastTime = -1.0;
    NSLog(@"Motion Processor Pause");
}

- (void) stop {
    [self pause];
    [self.motionManager stopDeviceMotionUpdates];
    NSLog(@"Motion Processor Stop");
}

- (void) runAsync: (NSTimer *)timer {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self run:timer];
    });
}

- (void) run: (NSTimer *)timer {
    ++ self.runningTimes;
    CMDeviceMotion *motion = self.motionManager.deviceMotion;
    // detect if motion has not been set up
    if (motion == nil) {
        NSLog(@"Motion not detected");
        return;
    }
    // detect if there is no reference attitude
    if (!self.referenceAttitude) {
        // get reference attitude
        self.referenceAttitude = self.motionManager.deviceMotion.attitude;
    }
    // init. last time
    if (self.lastTime < 0) {
        self.lastTime = motion.timestamp;
    }
    // get current attitude and compute rotation matrix
    CMAttitude *currentAttitude = motion.attitude;
    [currentAttitude multiplyByInverseOfAttitude:self.referenceAttitude];
    // compute grivaty
    CMAcceleration grivaty = [self computeGrivaty:currentAttitude.rotationMatrix];
    // deal with tilt
    [self tilt:grivaty interval:(motion.timestamp - self.lastTime)];
    // output per second if debug is enabled
    Model *m = [[Model class] instance];
    [[ModelUtilities class] debugWithDetect:self.runningTimes
                                   interval:self.flushInterval
                                     format:@"processed grivaty [%f, %f, %f]\ncanvas [%f, %f]",
                                            grivaty.x, grivaty.y, grivaty.z,
                                            m.canvasX, m.canvasY];
    // update last time timestamp
    self.lastTime = motion.timestamp;
}

- (void) tilt: (CMAcceleration)grivaty interval: (NSTimeInterval)interval {
    /* code that haven't been optimized, just for easy-reading */
    /* Note that the background must be larger than the device frame */
    // cache old values
    Model *model = [[Model class] instance];
    float oldAimX = model.aim.x, oldAimY = model.aim.y;
    float oldCanvasX = model.canvasX, oldCanvasY = model.canvasY;
    // compute raw increasement
    // I want the rate of movement to be more when user tilted more
    // which means I need a factor which combines grivaty (the "pow" part)
    float x = (float)(grivaty.x * 9.8 * interval * pow(fabs(grivaty.x) * 9.8, 2));
    float y = (float)(grivaty.y * 9.8 * interval * pow(fabs(grivaty.y) * 9.8, 2));
    // get aim increasement
    float aimIncX = y, aimIncY = -x;
    /* this step is to make sure that the aim won't go outside of the canvas */
    // need to move aim first, canvas move will need te movement of aim
    model.aim.x += aimIncX;
    model.aim.y += aimIncY;
    // check if aim out of canvas and adjust it to go within the canvas
    model.aim.x = model.aim.x < 0.f ? 0.f : model.aim.x;
    model.aim.x = model.aim.x > model.canvasW ? model.canvasW : model.aim.x;
    model.aim.y = model.aim.y < 0.f ? 0.f : model.aim.y;
    model.aim.y = model.aim.y > model.canvasH ? model.canvasH : model.aim.y;
    /* this step is to make sure that the canvas won't go ouside of the device frame */
    // get the new device walls in the canvas frame
    WALLS devWalls = [[ModelUtilities class] devWallsInCanvasByAim];
    if (devWalls.left < 0.f) {
        model.canvasX = 0.5 * model.canvasW;
    } else if (devWalls.right > model.canvasW) {
        model.canvasX = model.deviceW - 0.5 * model.canvasW;
    } else {
        model.canvasX -= aimIncX;
    }
    
    if (devWalls.bottom < 0.f) {
        model.canvasY = 0.5 * model.canvasH;
    } else if (devWalls.top > model.canvasH) {
        model.canvasY = model.deviceH - 0.5 * model.canvasH;
    } else {
        model.canvasY -= aimIncY;
    }
    
    // fire canvas or aim move event
    
    if (model.aim.x != oldAimX || model.aim.y != oldAimY) {
        [model fireTargetMoveEvent:model.aim];
    }
    
    if (model.canvasX != oldCanvasX || model.canvasY != oldCanvasY) {
        [model fireCanvasMoveEvent];
    }
}

- (CMAcceleration) computeGrivaty: (CMRotationMatrix)rotationMatrix {
    // compute gravity in reference frame
    CMAcceleration g;
    g.x = -rotationMatrix.m13;
    g.y = -rotationMatrix.m23;
    g.z = -rotationMatrix.m33;
    return g;
}


@end
