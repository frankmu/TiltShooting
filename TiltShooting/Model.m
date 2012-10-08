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

#define DEFAULT_START_LEVEL 1
#define DEFAULT_INTERVAL (1/30.f)
typedef BUBBLE_RULE (^fireEventBlock)(id<CoreEventListener>);

@interface Model()

@property (strong) NSMutableArray *listenerList;
@property (strong) ModelDaemon *daemon;
@property (strong) MotionProcessor *motionProcessor;
@property (strong) NSMutableSet *targetSet;
@end

@implementation Model

@synthesize enemyList = _enemyList;
@synthesize listenerList = _listenerList;
@synthesize targetSet = _targetSet;
@synthesize map2Box2D = _map2Box2D;
@synthesize daemon = _daemon;
@synthesize aim = _aim;
@synthesize canvasX = _canvasX, canvasY = _canvasY,
            canvasW = _canvasW, canvasH = _canvasH;
@synthesize deviceW = _deviceW, deviceH = _deviceH;
@synthesize flushInterval = _flushInterval;
@synthesize hasRecord = _hasRecord;
@synthesize status = _status;
@synthesize debug = _debug;
@synthesize shootHappen = _shootHappen;
@synthesize shootPoint = _shootPoint;

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
        self.enemyList = [[NSMutableArray alloc] init];
        self.listenerList = [[NSMutableArray alloc] init];
        self.bombList = [[NSMutableArray alloc] init];
        self.targetSet = [[NSMutableSet alloc] init];
        self.map2Box2D = [[Map2Box2D alloc] init];
        self.aim = [[Aim alloc] initWithX:0.f Y:0.f];
        // default canvas and device setting
        [self decideCanvasX:240.0f canvasY:160.0f canvasWidth:1440.0f
               canvasHeight:960.0f deviceWidth:480.0f deviceHeight:320.0f];
        // int conf
        self.hasRecord = 0;
        self.status = STOPPED;
        self.debug = YES;
        self.flushInterval = DEFAULT_INTERVAL;
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
    self.aim.x = canvasW / 2.0f;
    self.aim.y = canvasH / 2.0f;
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
    // for experiment
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        // the order to init. is important
        self.status = RUNNING;
        [self.map2Box2D createWorldWithWidth:self.canvasW height:self.canvasH];
        [[GameBrain class] initGameWithLevel:1];
        [self.daemon start];
        [self.motionProcessor start];
        [self fireGameInitFinishedEvent];
        [self fireTargetAppearEvent:self.aim];
        NSLog(@"Model Start");
    });
}

- (void) pause {
    self.status = PAUSING;
    [self.daemon stop];
    [self.motionProcessor pause];
}

- (void) save {
    // not supportted yet
}

- (void) resume {
    self.status = RUNNING;
    [self.daemon start];
    [self.motionProcessor resume];
}

- (void) stop {
    // order is important
    self.status = STOPPED;
    [self.motionProcessor stop];
    [self.daemon stop];
    [self.targetSet removeAllObjects];
    [self.enemyList removeAllObjects];
    [self.bombList removeAllObjects];
    [self.map2Box2D destoryWorld];
    self.shootHappen = NO;
    NSLog(@"Model Stop");
}

- (void) shoot {
    _shootPoint.x = self.aim.x;
    _shootPoint.y = self.aim.y;
    self.shootHappen = YES;
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

- (void) fireImpactEvent:(Target *)t1 by:(Target *)t2 {
    [self fireEvent:@selector(impact:by:) with:^(id<CoreEventListener> listener) {
        return (BUBBLE_RULE) [listener impact:t1 by:t2];
    }];
}

- (void) fireEvent: (SEL)handler with: (fireEventBlock) block {
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

- (void) createBomb:(Bomb *)bomb {
    [self createTarget:bomb to:self.bombList];
}

- (void) createEnemy:(Enemy *)enemy {
    [self createTarget:enemy to:self.enemyList];
}

- (void) createTarget:(Target *)target to:(NSMutableArray *)list {
    if (![self.targetSet containsObject:target]) {
        [list addObject:target];
        [self.targetSet addObject:target];
        [self.map2Box2D attachTarget:target];
        [self fireTargetAppearEvent:target];
    }
}

- (void) deleteBomb:(Bomb *)bomb {
    [self deleteTarget:bomb from:self.bombList];
}

- (void) deleteEnemy:(Enemy *)enemy {
    [self deleteTarget:enemy from:self.enemyList];
}

- (void) deleteTarget:(Target *)target from:(NSMutableArray *)list {
    if ([self.targetSet containsObject:target]) {
        [list addObject:target];
        [self.targetSet removeObject:target];
        [self.map2Box2D deleteTarget:target];
        [self fireTargetDisappearEvent:target];
    }
}

- (void) resetShootHappen {
    self.shootHappen = NO;
}
@end
