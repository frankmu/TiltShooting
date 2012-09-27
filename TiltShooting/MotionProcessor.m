//
//  MotionProcessor.m
//  TiltShooting
//
//  Created by yirui zhang on 9/26/12.
//
//

#import "MotionProcessor.h"
#import <CoreMotion/CoreMotion.h>

@interface MotionProcessor()
@property (strong) CMMotionManager *motionManager;
@property (strong) CMAttitude *referenceAttitude;
@property (weak) NSTimer *timer;

- (void) run: (NSTimer *)timer;
@end

@implementation MotionProcessor
@synthesize motionManager = _motionManager;
@synthesize timer = _timer;
@synthesize referenceAttitude = _referenceAttitude;


- (void) start {
    // start listening to motion events
    // lazy alloc
    if (self.motionManager == nil) {
        self.motionManager = [[CMMotionManager alloc] init];
    }
    // detect if the device support motion
    if (![self.motionManager isDeviceMotionAvailable]) {
        [NSException raise:@"Motion not supported" format:@"the device doesn't support motion"];
    }
    // start listening motion events
    [self.motionManager startDeviceMotionUpdates];
    // init motion interval
    self.motionManager.accelerometerUpdateInterval = 0.01;
    // get reference attitude
    self.referenceAttitude = self.motionManager.deviceMotion.attitude;
    // cancel a pre-existing timer.
    [self.timer invalidate];
    // init. new timer
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1/100.f
                                                      target:self
                                                    selector:@selector(run:)
                                                    userInfo:nil
                                                     repeats:YES];
    self.timer = timer;
}

- (void) stop {
    [self.timer invalidate];
    [self.motionManager stopDeviceMotionUpdates];
}

- (void) run: (NSTimer *)timer {
    CMDeviceMotion *motion = self.motionManager.deviceMotion;
    if (motion == nil) {
        return;
    }
    
}


@end
