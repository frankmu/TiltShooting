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
#define DEFAULT_INTERVAL (1/60.f)
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
    [[ModelUtilities class] debugWithDetect:self.runningTimes
                                   interval:self.flushInterval
                                     format:@"processed grivaty [%f, %f, %f]",
                                            grivaty.x, grivaty.y, grivaty.z];
    // update last time timestamp
    self.lastTime = motion.timestamp;
}

- (void) tilt: (CMAcceleration)grivaty interval: (NSTimeInterval)interval {
    float x = (float)(grivaty.x * 9.8 * interval * pow(fabs(grivaty.x) * 9.8, 2));
    float y = (float)(grivaty.y * 9.8 * interval * pow(fabs(grivaty.y) * 9.8, 2));
    Model *model = [[Model class] instance];
    // get increasement in x && y
    float canvasIncX = -y, canvasIncY = x;
    BOOL canvasChange = NO, aimChange = NO;
    float aimIncX = -canvasIncX, aimIncY = -canvasIncY;
    // get walls
    float leftWall = model.canvasX - 0.5f * model.canvasW;
    float bottomWall = model.canvasY - 0.5f * model.canvasH;
    float topWall = model.canvasY + 0.5f * model.canvasH;
    float rightWall = model.canvasX + 0.5f * model.canvasW;
    // move canvas only if device won't go out of canvas
    if (canvasIncX != 0.0f &&
        !(leftWall + canvasIncX >= 0) && !(rightWall + canvasIncX <= 0)) {
        model.canvasX += canvasIncX;
        canvasChange = YES;
    }
    if (canvasIncY != 0.0f &&
        !(bottomWall + canvasIncY >= 0 && !(topWall + canvasIncY <= 0))) {
        model.canvasY += canvasIncY;
        canvasChange = YES;
    }
    // move aim only if aim won't go out of canvas
    // fire canvas or aim move event
    if (canvasChange) {
        [model fireCanvasMoveEvent];
    }
    
    if (aimChange) {
        [model fireTargetMoveEvent:model.aim];
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
