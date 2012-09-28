//
//  ModelDaemon.m
//  TiltShooting
//
//  Created by yirui zhang on 9/18/12.
//
//

#import "ModelDaemon.h"
#define DEFAULT_FLUSH_INTERVAL (1/30.f)

@interface ModelDaemon ()

@property (weak) NSTimer *timer;
@property NSUInteger runningTimes;
@end

@implementation ModelDaemon

- (id) init {
    if (self = [super init]) {
        self.runningTimes = 0;
        self.flushInterval = DEFAULT_FLUSH_INTERVAL;
    }
    return self;
}

- (void) start {
    [self startWithInterval:DEFAULT_FLUSH_INTERVAL];
}

- (void) startWithInterval:(NSTimeInterval)interval {
    self.flushInterval = interval;
    // cancel a pre-existing timer.
    [self.timer invalidate];
    // init. new timer
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.flushInterval
                                                      target:self
                                                    selector:@selector(run:)
                                                    userInfo:nil
                                                     repeats:YES];
    self.timer = timer;
    NSLog(@"Model Daemon Start");
}

- (void) stop {
    [self.timer invalidate];
    NSLog(@"Model Daemon Stop");
}

- (void) run: (NSTimer *) timer {
    // work normally
    ++ self.runningTimes;
    // currently no one can move, they all static
}

@end
