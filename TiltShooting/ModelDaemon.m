//
//  ModelDaemon.m
//  TiltShooting
//
//  Created by yirui zhang on 9/18/12.
//
//

#import "ModelDaemon.h"
#import "Model.h"
#define DEFAULT_FLUSH_INTERVAL (1/60.f)

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
    NSTimer *timer = [NSTimer timerWithTimeInterval:self.flushInterval
                                                      target:self
                                                    selector:@selector(runAsync:)
                                                    userInfo:nil
                                                     repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    self.timer = timer;
    NSLog(@"Model Daemon Start");
}

- (void) stop {
    [self.timer invalidate];
    NSLog(@"Model Daemon Stop");
}

- (void) runAsync: (NSTimer *)timer {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self run:timer];
    });
}

- (void) run: (NSTimer *) timer {
    id<ModelFullInterface> m = [[Model class] instance];
    //Map2Box2D *map = [m map2Box2D];
    // work normally
    ++ self.runningTimes;
    if ([m shootHappen]) {
        POINT shootPos = [m shootPoint];
        [m resetShootHappen];
        Target *target = [self detectShoot:shootPos];
        if (target != nil) {
            [m fireTargetHitEvent:target];
            [m fireTargetDisappearEvent:target];
        }
    }
}

- (Target *) detectShoot: (POINT)p {
    // just for test
    id<ModelFullInterface> m = [[Model class] instance];
    Target *ret = nil;
    for (Target *t in [m enemyList]) {
        if (p.x < (t.x + 20.f) && p.x > (t.x - 20.0f) &&
            p.y < (t.y + 20.0f) && p.y > (t.y - 20.0f)) {
            ret = t;
            break;
        }
    }
    
    if (ret != nil) {
        return ret;
    }
    
    for (Target *t in [m bombList]) {
        if (p.x < (t.x + 20.f) && p.x > (t.x - 20.0f) &&
            p.y < (t.y + 20.0f) && p.y > (t.y - 20.0f)) {
            ret = t;
            break;
        }
    }
    return ret;
}

@end
