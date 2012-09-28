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
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.flushInterval
                                                      target:self
                                                    selector:@selector(run:)
                                                    userInfo:nil
                                                     repeats:YES];
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
    NSTimeInterval interval = motion.timestamp - self.lastTime;
    double x = grivaty.x * 9.8 * interval * pow(fabs(grivaty.x) * 9.8, 2);
    double y = grivaty.y * 9.8 * interval * pow(fabs(grivaty.y) * 9.8, 2);
    Model *model = [[Model class] instance];
    [model setCanvasX:model.canvasX + y Y:model.canvasY - x];
    [model fireCanvasMoveEvent];
    // output per second if debug is enabled
    [[ModelUtilities class] debugWithDetect:self.runningTimes
                                   interval:self.flushInterval
                                     format:@"processed grivaty [%f, %f, %f]\ncanvas [%f, %f]",
                                            grivaty.x, grivaty.y, grivaty.z, model.canvasX, model.canvasY];
    // update last time timestamp
    self.lastTime = motion.timestamp;
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
