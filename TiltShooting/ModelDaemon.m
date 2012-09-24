//
//  ModelDaemon.m
//  TiltShooting
//
//  Created by yirui zhang on 9/18/12.
//
//

#import "ModelDaemon.h"
#define DEFAULT_FLUSH_INTERVAL (1/30)

typedef enum {
    STOP, RUNNING, PAUSE
}STATUS;

@interface ModelDaemon ()

@property (weak) NSTimer *timer;
@property NSUInteger runningTimes;
@property STATUS status;

@end

@implementation ModelDaemon

- (id) init {
    if (self = [super init]) {
        self.runningTimes = 0;
        self.status = STOP;
    }
    return self;
}

- (void) start {
    // cancel a pre-existing timer.
    [self.timer invalidate];
    // init. new timer
    self.status = RUNNING;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:DEFAULT_FLUSH_INTERVAL
                                                      target:self
                                                    selector:@selector(run:)
                                                    userInfo:nil
                                                     repeats:YES];
    self.timer = timer;
}

- (void) stop {
    self.status = STOP;
}

- (void) pause {
    self.status = PAUSE;
}

- (void) resume {
    self.status = RUNNING;
}

- (void) run: (NSTimer *) timer {
    if (self.status == STOP) {
        [self.timer invalidate];
        self.timer = nil;
        return;
    } else if (self.status == PAUSE) {
        return;
    }
    // work normally
    ++ self.runningTimes;
    
    // currently no one can move, they all static
}

@end
