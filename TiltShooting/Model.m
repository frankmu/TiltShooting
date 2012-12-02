//
//  Model.m
//  TiltShooting
//
//  Created by yan zhuang on 12-9-17.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Model.h"
#import "ModelDaemon.h"
#import "GameBrain.h"
#import "MotionProcessor.h"
#import "CoreEventListener.h"
#import "Map2Box2D.h"
#import "TimeMinus.h"
#import "TimePlus.h"
#import "BulletBox.h"
#import "cocos2d.h"
#import "TimerTask.h"
#import "Monster.h"
#import "Spider.h"
#import "Vampire.h"

#define DEFAULT_START_LEVEL 1
#define DEFAULT_INTERVAL (1/30.f)
typedef BUBBLE_RULE (^fireEventBlock)(id<CoreEventListener>);

@interface Model()

@property (strong, atomic) NSMutableArray *listenerList;
@property (strong) MotionProcessor *motionProcessor;
@property (strong, atomic) NSMutableSet *targetSet;
//@property (strong, atomic) NSMutableArray *eventList;
@end

@implementation Model
+ (id<ModelInterface>) instance {
    static id<ModelInterface> shared = nil;
    static dispatch_once_t onceToken;
    // only execuate once in the lifetime of a app.
    dispatch_once(&onceToken, ^{
        shared = [[Model alloc] init];
    });
    return shared;
}

- (id) init {
    NSLog(@"Model Init.");
    if (self = [super init]) {
        self.daemon = [[ModelDaemon alloc] init];
        self.motionProcessor = [[MotionProcessor alloc] init];
        self.targetList = [[NSMutableArray alloc] init];
        self.listenerList = [[NSMutableArray alloc] init];
        self.timerTaskList = [[NSMutableArray alloc] init];
        self.targetSet = [[NSMutableSet alloc] init];
        self.weaponList = [[NSMutableArray alloc] init];
        self.shootPoints = [[NSMutableArray alloc] init];
        self.map2Box2D = [[Map2Box2D alloc] init];
        self.aim = [[Aim alloc] initWithX:0.f Y:0.f];
        // default canvas and device setting
        [self decideCanvasX:240.0f canvasY:160.0f canvasWidth:1440.0f
               canvasHeight:960.0f deviceWidth:480.0f deviceHeight:320.0f];
        // init conf
        self.hasRecord = 0;
        self.status = STOPPED;
        self.debug = YES;
        self.flushInterval = DEFAULT_INTERVAL;
        // init other params
        self.volume = 100.0f;
        self.score = 0.0f;
        self.bonus = 0.0f;
        self.combo = 0;
        self.remainTime = 60.0;
        self.maxTime = 60.f;
    }
    return self;
}

- (void) setCanvasX:(float)cx Y:(float)cy {
    self.canvasX = cx;
    self.canvasY = cy;
}

- (void) setCanvasWidth:(float)cw height:(float)ch {
    self.canvasW = cw;
    self.canvasH = ch;
}

- (void) setDeviceWidth:(float)dw height:(float)dh {
    self.deviceW = dw;
    self.deviceH = dh;
}

- (void) decideCanvasX:(float)canvasX canvasY:(float)canvasY canvasWidth:(float)canvasW canvasHeight:(float)canvasH deviceWidth:(float)deviceW deviceHeight:(float)deviceH {
    self.canvasX = canvasX;
    self.canvasY = canvasY;
    self.canvasW = canvasW;
    self.canvasH = canvasH;
    self.deviceW = deviceW;
    self.deviceH = deviceH;
    [self resetAim];
}

- (void) addToCoreEventListenerList:(id<CoreEventListener>)listener {
    [self.listenerList addObject: listener];
}

- (void) addToCoreEventListenerlist: (id<CoreEventListener>) listener
                           priority: (int) priority {
    priority = priority < 0 ? 0 : priority;
    priority = priority > self.listenerList.count ? self.listenerList.count : priority;
    [self.listenerList insertObject:listener atIndex:priority];
}

/* Game Control Interface */

- (void) start {
    [self startWithLevel: DEFAULT_START_LEVEL];
}

- (void) startWithLevel: (int) level {
    // some work must be done first in order to init others
    if (self.status != STOPPED) {
        return;
    }
    self.currentLevel = level;
    [self.map2Box2D createWorldWithWidth:self.canvasW height:self.canvasH];
    self.status = RUNNING;
    [[GameBrain class] initGameSceneWithLevel:1];
    // for experiment
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        // the order to init. is important
          
        [self.daemon start];
        [self.motionProcessor start];
        [self fireGameInitFinishedEvent];
        [self resetAim];
        [self fireTargetAppearEvent:self.aim];
        [self fireWeaponStatusChangeEvent:self.currentWeapon];
        NSLog(@"Model Start");
    });
}

- (void) pause {
    self.status = PAUSING;
    [self.daemon stop];
    [self.motionProcessor pause];
    NSLog(@"Model Paused");
}

- (void) save {
    // not supportted yet
}

- (void) resume {
    self.status = RUNNING;
    [self.daemon start];
    [self.motionProcessor resume];
}

- (void) resetAim {
    self.aim.x = self.canvasW / 2.0f;
    self.aim.y = self.canvasH / 2.0f;
}

- (void) resetCanvas {
    self.canvasX = self.deviceW / 2.0f;
    self.canvasY = self.deviceH / 2.0f;
}

- (void) resetTime {
    self.remainTime = self.maxTime;
}

- (void) stop {
    // order is important
    self.status = STOPPED;
    [self.motionProcessor stop];
    [self.daemon stop];
    [self.targetSet removeAllObjects];
    [self.targetList removeAllObjects];
    [self.weaponList removeAllObjects];
    [self.timerTaskList removeAllObjects];
    self.currentWeapon = nil;
    [self.map2Box2D destoryWorld];
    self.shootHappen = NO;
    self.reloadHappen = NO;
    self.combo = 0;
    self.score  = 0.f;
    self.bonus = 0.f;
    [self resetCanvas];
    [self resetAim];
    [self resetTime];
    [self fireTargetMoveEvent:self.aim];
    NSLog(@"Model Stop");
}


- (void) enableDebug {
    self.debug = YES;
}

- (void) disableDebug {
    self.debug = NO;
}

- (void) fireCanvasMoveEvent {
    [self fireEvent:@selector(canvasMovetoX:Y:) with:^(id<CoreEventListener> listener) {
        return (BUBBLE_RULE) [listener canvasMovetoX:self.canvasX Y:self.canvasY];
    }];
}

- (void) fireTargetAppearEvent:(Target *)target {
    [self fireEvent:@selector(targetAppear:) with: ^(id<CoreEventListener> listener) {
        return (BUBBLE_RULE)[listener targetAppear:target];
    }];
}

- (void) fireTargetDisappearEvent:(Target *)target {
    [self fireEvent:@selector(targetDisAppear:) with: ^(id<CoreEventListener> listener) {
        return (BUBBLE_RULE)[listener targetDisAppear:target];
    }];
}

- (void) fireTargetMoveEvent:(Target *)target {
    [self fireEvent:@selector(targetMove:) with: ^(id<CoreEventListener> listener) {
        return (BUBBLE_RULE)[listener targetMove:target];
    }];
}

- (void) fireTargetHitEvent:(Target *)target {
    [self fireEvent:@selector(targetHit:) with: ^(id<CoreEventListener> listener) {
        return (BUBBLE_RULE)[listener targetHit:target];
    }];}

- (void) fireGameInitFinishedEvent {
    [self fireEvent:@selector(gameInitFinished) with:^(id<CoreEventListener> listener) {
        return (BUBBLE_RULE)[listener gameInitFinished];
    }];
}

- (void) fireNeedReloadEvent{
    [self fireEvent:@selector(needReload) with:^(id<CoreEventListener> listener) {
        return (BUBBLE_RULE)[listener needReload];
    }];
}

//- (void) fireImpactEvent:(Target *)t1 by:(Target *)t2 {
//    [self fireEvent:@selector(impact:by:) with:^(id<CoreEventListener> listener) {
//        return (BUBBLE_RULE) [listener impact:t1 by:t2];
//    }];
//}

//- (void) fireWinEvent {
//    [self fireEvent:@selector(win) with:^(id<CoreEventListener> listener) {
//        return (BUBBLE_RULE) [listener win];
//    }];
//}
//
//- (void) fireLoseEvent {
//    [self fireEvent:@selector(lose) with:^(id<CoreEventListener> listener) {
//        return (BUBBLE_RULE) [listener lose];
//    }];
//}

- (void) fireGameFinishEvent {
    [self fireEvent:@selector(gameFinish) with:^(id<CoreEventListener> listener) {
        return (BUBBLE_RULE) [listener gameFinish];
    }];
}

- (void) fireScoreEvent: (float)score {
    [self fireEvent:@selector(score:) with:^(id<CoreEventListener> listener) {
        return (BUBBLE_RULE) [listener score:score];
    }];
}

- (void) fireTimeEvent:(NSTimeInterval)time {
    [self fireEvent:@selector(time:) with:^(id<CoreEventListener> listener) {
        return (BUBBLE_RULE) [listener time:time];
    }];
}

- (void) fireWeaponStatusChangeEvent:(WeaponBase *)currentWeapon {
    [self fireEvent:@selector(weaponStatusChanged:)
               with:^(id<CoreEventListener> listener) {
        return (BUBBLE_RULE) [listener weaponStatusChanged:currentWeapon];
    }];
}

- (void) fireTargetMissEvent:(float)x y:(float)y {
    [self fireEvent:@selector(targetMissX:y:)
               with:^(id<CoreEventListener> listener) {
        return (BUBBLE_RULE) [listener targetMissX:x y:y];
    }];
}

- (void) fireBonusEvent:(float)bonus {
    [self fireEvent:@selector(bonus:)
               with:^(id<CoreEventListener> listener) {
                   return (BUBBLE_RULE) [listener bonus:bonus];
    }];
}

- (void) fireFlushFinish {
    [self fireEvent:@selector(flushFinish)
               with:^(id<CoreEventListener> listener) {
        return (BUBBLE_RULE) [listener flushFinish];
    }];
}

- (void) firePrepareAppearEvent:(Target *)t time:(NSTimeInterval)time{
    [self fireEvent:@selector(prepareToAppear:time:)
               with:^(id<CoreEventListener> listener) {
        return (BUBBLE_RULE) [listener prepareToAppear:t time:time];
    }];
}

- (void) firePrepareDisappearEvent:(Target *)t time:(NSTimeInterval)time{
    [self fireEvent:@selector(prepareToDisappear:time:)
               with:^(id<CoreEventListener> listener) {
        return (BUBBLE_RULE) [listener prepareToDisappear:t time:time];
    }];
}

- (void) fireTargetResizeEvent:(Target *)target {
    [self fireEvent:@selector(targetResize:)
               with:^(id<CoreEventListener> listener) {
        return (BUBBLE_RULE) [listener targetResize:target];
    }];
}

- (void) fireEvent: (SEL)handler with: (fireEventBlock) block {
//    for (id<CoreEventListener> listener in self.listenerList) {
//        if ([listener respondsToSelector:handler]) {
//            BUBBLE_RULE rule;
//            rule = block(listener);
//            if (rule == BUBBLE_STOP) {
//                return;
//            }// bubble detect
//        }// selector detect
//    }// foreach in listener list
    dispatch_async(dispatch_get_main_queue(), ^ {
        BUBBLE_RULE rule;
        for (id<CoreEventListener> listener in self.listenerList) {
            if ([listener respondsToSelector:handler]) {
                rule = block(listener);
                if (rule == BUBBLE_STOP) {
                    return;
                }// bubble detect
            }// selector detect
        }// foreach in listener list
    });
}

- (void) createTarget:(Target *)target{
    if (![self.targetSet containsObject:target] && ![self.map2Box2D isLock]) {
        [self.targetList addObject:target];
        [self.targetSet addObject:target];
        [self.map2Box2D attachTarget:target];
        [self fireTargetAppearEvent:target];
    }
}

- (void) deleteTarget:(Target *)target{
    if ([self.targetSet containsObject:target]) {
        NSLog(@"delete target %@", target);
        [self removeTimerTask:target];
        [self.map2Box2D deleteTarget:target];
        [self.targetList removeObject:target];
        [self.targetSet removeObject:target];
        [self.currentWeapon increaseManaByBonus:target.bonus];
        [self fireTargetDisappearEvent:target];
    }
}

- (void) resetShootHappen {
    self.shootHappen = NO;
}

- (void) incScore:(float)score {
    self.score += score;
}

- (void) changeTime:(NSTimeInterval)time {
    self.remainTime = time;
    [self fireTimeEvent:self.remainTime];
}

- (void) _shootWithUseSkill: (BOOL)useSkill {
    POINT *newP = [[POINT alloc]
                   initWithX:self.aim.x y:self.aim.y useSkill:useSkill];
    [self.shootPoints addObject:newP];
    self.shootHappen = YES;
}

- (void) shoot {
    [self _shootWithUseSkill:NO];
}

- (void) specialShoot {
    [self _shootWithUseSkill:YES];
}

- (void) setTime:(NSTimeInterval)time {
    self.maxTime = time;
    self.remainTime = time; 
}

- (void) switchToNextWeapon {
    self.switchWeaponChange += 1;
}

- (void) switchToPreviousWeapon {
    self.switchWeaponChange -= 1;
}


- (void) updateScoreByBonus:(float)bonus {
    [self incScore:bonus * 3];
}

- (void) updateScoreByDestroy:(Target *)t {
    [self incScore:t.hp];
}

- (void) updateScoreByHit:(Target *)t {
    self.combo = t != nil ? self.combo + 1 : 0;
    if (self.combo != 0) {
        [self incScore: self.combo * t.bonus];
    }
}

- (void) incBonus:(float)bonus {
    self.bonus += bonus;
}

- (void) resetSwitchWeaponChange {
    self.switchWeaponChange = 0;
}

+ (TYPE_TARGET) targetType:(Target *)target {
    if ([target isMemberOfClass:[Enemy class]]) {
        return TYPE_ENEMY;
    } else if ([target isMemberOfClass:[Aim class]]) {
        return TYPE_AIM;
    } else if ([target isMemberOfClass: [TimeMinus class]]) {
        return TYPE_TIME_MINUS;
    } else if ([target isMemberOfClass:[TimePlus class]]) {
        return TYPE_TIME_PLUS;
    } else if ([target isMemberOfClass:[Spider class]]) {
        return TYPE_SPIDER;
    } else if([target isMemberOfClass:[BulletBox class]]) {
        return TYPE_BULLET_BOX;
    } else if([target isMemberOfClass:[Monster class]]) {
        return TYPE_MONSTER;
    } else if([target isMemberOfClass:[Vampire class]]) {
        return TYPE_VAMPIRE;
    }
    return TYPE_UNKNOWN;
}

- (void) insertToTimer: (Target*)target time: (NSTimeInterval)time
                  list:(NSMutableArray*)list {
    target.timer = time;
    if (![list containsObject:target]) {
        [list addObject:target];
    }
}

- (void) appear:(Target *)target time:(NSTimeInterval)time {
    [self addTimerTask:time aux:target ID:target block:^NSTimeInterval(id aux) {
        id<ModelFullInterface> m = [Model instance];
        [m createTarget:(Target *)aux];
        return -1.f;
    }];
    [self firePrepareAppearEvent:target time:time];
}

- (void) disappear:(Target *)target time:(NSTimeInterval)time {
    [self addTimerTask:time aux:target ID:target block:^NSTimeInterval(id aux) {
        id<ModelFullInterface> m = [Model instance];
        [m deleteTarget:(Target *)aux];
        return -1.f;
    }];
    [self firePrepareDisappearEvent:target time:time];
}

- (void) addTimerTask: (NSTimeInterval)time aux:(id) aux ID:(id)obj
                block: (timerTaskblock) block{
    [self.timerTaskList addObject:[[TimerTask alloc]
                                   initWithTime:time block:block aux:aux ID:obj]];
}

- (void) removeTimerTask: (id) obj {
    NSMutableArray* list = [[NSMutableArray alloc] init];
    for (TimerTask* t in self.timerTaskList) {
        if ([t.ID isEqual:obj]) {
            [list addObject:t];
        }// if
    }// for
    [self.timerTaskList removeObjectsInArray:list];
}

- (void) refreshTimerTaskList: (NSTimeInterval) time {
    NSMutableArray* tbd = [[NSMutableArray alloc] init];
    for (TimerTask* task in [self.timerTaskList copy]) {
        task.time -= time;
        if (task.time <= 0) {
            NSTimeInterval inc = task.block(task.aux);
            task.time += inc;
            if (task.time <= 0) {
                [tbd addObject:task];
            }
        }
    }
    [self.timerTaskList removeObjectsInArray:tbd];
}
@end
