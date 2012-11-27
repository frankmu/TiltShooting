//
//  ModelDaemon.m
//  TiltShooting
//
//  Created by yirui zhang on 9/18/12.
//
//

#import "ModelDaemon.h"
#import "Model.h"
#import "GameBrain.h"

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
    self.runningTimes = 0;
    [self.timer invalidate];
    NSLog(@"Model Daemon Stop");
}

- (void) runAsync: (NSTimer *)timer {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self run:timer];
    });
}

- (void) run: (NSTimer *) timer {
    id<ModelFullInterface> m = [[Model class] instance];
    
    if ([m status] != RUNNING) {
        return;
    }
    
    ++ self.runningTimes;
    BOOL runEvery2Time = self.runningTimes % 2 == 0;
    [self runEveryTime:timer];
    if (runEvery2Time) {
        [self runEvery2Time:timer];
    }
    
    [m fireFlushFinish];
}

- (void) runEveryTime: (NSTimer *) timer {
    id<ModelFullInterface> m = [[Model class] instance];
    // flush the time
    NSTimeInterval newTime = [m remainTime] - self.timer.timeInterval;
    newTime = newTime < 0.0 ? 0.0 : newTime;
    [m setRemainTime:newTime];
    if (newTime - 0.0 < 10e-5) {
        [m fireGameFinishEvent];
        [m stop];
        return;
    }
    
    [[m map2Box2D] step];
    if ([m reloadHappen]) {
        [m setReloadHappen:NO];
        [[m currentWeapon] reload];
        [m fireWeaponStatusChangeEvent:[m currentWeapon]];
    }
    
    int switchWeaponChange = [m switchWeaponChange];
    if (switchWeaponChange != 0) {
        [m resetSwitchWeaponChange];
        NSMutableArray *weaponList = [m weaponList];
        NSUInteger index = [weaponList indexOfObject: [m currentWeapon]];
        index = (index + switchWeaponChange) % [weaponList count];
        WeaponBase *newWeapon = [weaponList objectAtIndex:index];
        [m setCurrentWeapon:newWeapon];
        [m fireWeaponStatusChangeEvent: [m currentWeapon]];
    }
    
    
    if ([m shootHappen]) {
        NSMutableArray *orgPoints = [m shootPoints];
        [m resetShootHappen];
        WeaponBase *currentWeapon = [m currentWeapon];
        
        if (![currentWeapon canShoot]) {
            [m fireNeedReloadEvent];
        } else {
            for (POINT *p in orgPoints) {
                BOOL hitted = NO;
                if (p.useSkill) {
                    hitted = [currentWeapon specialSkillWithX:p.x y:p.y];
                } else {
                    hitted = [currentWeapon shootWithX:p.x y:p.y];
                }
                
                if (!hitted) {
                    [m updateScoreByHit:nil];
                    [m fireTargetMissEvent:p.x y:p.y];
                } else {
                    [m fireScoreEvent: [m score]];
                    [m fireBonusEvent:[m bonus]];
                }
            }
            // update weapon status only in need
            if ([orgPoints count] != 0) {
                [m fireWeaponStatusChangeEvent: [m currentWeapon]];
            }
        }
        [orgPoints removeAllObjects];
    }
    [[GameBrain class] refreshGameWithLevel:[m currentLevel]];
    if ([m canvasMoved]) {
        [m setCanvasMoved:NO];
        [m fireCanvasMoveEvent];
    }
    
    if ([m aimMoved]) {
        [m setAimMoved:NO];
        [m fireTargetMoveEvent:[m aim]];
    }
    
}

- (void) runEvery2Time: (NSTimer *) timer {
    id<ModelFullInterface> m = [[Model class] instance];
    [m fireTimeEvent:[m remainTime]];
}


@end
