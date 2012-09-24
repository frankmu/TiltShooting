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

#define DEFAULT_START_LEVEL 1

@interface Model()

@property (strong) NSMutableArray *listenerList;
@property (strong) ModelDaemon *daemon;
@property float canvasX, canvasY, canvasW, canvasH;
@property float deviceW, deviceH;

@end

@implementation Model

@synthesize enemyList = _enemyList;
@synthesize listenerList = _listenerList;
@synthesize daemon = _daemon;
@synthesize aim = _aim;
@synthesize canvasX = _canvasX, canvasY = _canvasY,
            canvasW = _canvasW, canvasH = _canvasH;
@synthesize deviceW = _deviceW, deviceH = _deviceH;
@synthesize flushInterval = _flushInterval;

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
    if (self = [super init]) {
        self.daemon = [[ModelDaemon alloc] init];
        self.enemyList = [[NSMutableArray alloc] init];
        self.listenerList = [[NSMutableArray alloc] init];
        self.bombList = [[NSMutableArray alloc] init];
        self.aim = [[Aim alloc] initWithPositionX:0.0 Y:0.0];
        // default canvas and device setting
        [self decideCanvasX:-200.0 canvasY:-200.0 canvasWidth:800
               canvasHeight:800 deviceWidth:960 deviceHeight:460];
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
    self.aim.x = canvasW / 2.0;
    self.aim.y = canvasH / 2.0;
}

- (void) addToCoreEventListenerList:(id<CoreEventListener>)listener {
    [self.listenerList addObject: listener];
}

- (void) addToCoreEventListenerlist: (id<CoreEventListener>) listener
                           priority: (int) priority {
    [self.listenerList insertObject:listener atIndex:priority];
}

/* Game Control Interface */

- (void) start {
    [self startWithLevel: DEFAULT_START_LEVEL];
}

- (void) startWithLevel: (int) level {
    // for experiment
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),
                   ^{
                       [[GameBrain class] initGameWithLevel:1];
                   });
}

- (void) pause {
    [self.daemon pause];
}

- (void) save {
    // not supportted yet
}

- (void) resume {
    [self.daemon resume];
}

- (void) stop {
    [self.daemon stop];
}

- (void) shoot:(Target *)target{
    
}

@end
