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
    // init. new last var
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
    if ([m status] != RUNNING) {
        return;
    }
    // work normally
    ++ self.runningTimes;
    
    // flush the time
    NSTimeInterval newTime = [m remainTime] - self.timer.timeInterval;
    newTime = newTime < 0.0 ? 0.0 : newTime;
    [m changeTime:newTime];
    if (newTime - 0.0 < 10e-5) {
        [m fireGameFinishEvent];
        [m stop];
    }
    
    if ([m reloadHappen]) {
        [m setReloadHappen:NO];
        [[m currentWeapon] reload];
    }
    
    if ([m shootHappen]) {
        NSMutableArray *orgPoints = [m shootPoints];
        //NSMutableArray *points = [orgPoints copy];
        //[orgPoints removeAllObjects];
        [m resetShootHappen];
        WeaponBase *currentWeapon = [m currentWeapon];
        
        if (![currentWeapon canShoot]) {
            [m fireNeedReloadEvent];
        } else {
        
            for (POINT *p in orgPoints) {
                NSLog(@"shoot test at %f %f", p.x, p.y);
                if (p.useSkill) {
                    [currentWeapon specialSkillWithX:p.x y:p.y];
                } else {
                    [currentWeapon shootWithX:p.x y:p.y];
                }
            }
        }
        [orgPoints removeAllObjects];
    }
}


@end
