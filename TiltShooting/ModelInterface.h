//
//  MotelInterface.h
//  TiltShooting
//
//  Created by yirui zhang on 9/17/12.
//  
//
//

#import <Foundation/Foundation.h>
#import "CoreEventListener.h"
#import "Aim.h"

typedef enum {
    RUNNING,
    PAUSING,
    STOPPED
} STATUS;

@protocol ModelInterface <NSObject>

@required
+ (id<ModelInterface>) instance;

- (void) addToCoreEventListenerList: (id<CoreEventListener>) listener;
- (void) addToCoreEventListenerlist: (id<CoreEventListener>) listener
                           priority: (int) priority;

/* Init. */
// typically, canvas is the "background" and device is the iphone screen
// canvas x and y are "background" positions in device coordinate
// init. these parameters is essential when program starts
- (void) decideCanvasX: (float)canvasX canvasY: (float)canvasY
             canvasWidth: (float)canvasW canvasHeight: (float) canvasH
             deviceWidth: (float) deviceW deviceHeight: (float) deviceH;

/* Core Control Interface */
- (void) setFlushInterval: (NSTimeInterval) interval;
- (double) flushInterval;

/* Game Control Interface */
- (void) start;
- (void) startWithLevel: (int) level;
- (void) pause;
- (void) resume;
- (void) stop;
- (void) save;
- (STATUS) status;
- (void) shoot;

/* Data Access Interface */
- (NSMutableArray *) enemyList;
- (NSMutableArray *) bombList;
- (Aim *) aim;
- (float) canvasX;
- (float) canvasY;
- (float) canvasW;
- (float) canvasH;
- (float) deviceW;
- (float) deviceH;
- (void) setCanvasX: (float) cx Y: (float) cy;
- (void) setCanvasWidth: (float) cw height: (float) ch;
- (void) setDeviceWidth: (float) dw height: (float)  dh;

/* Conf. */
- (int) hasRecord;

/* debug */
- (void) enableDebug;
- (void) disableDebug;
- (BOOL) debug;
@end
