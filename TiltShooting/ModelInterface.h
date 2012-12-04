//
//  MotelInterface.h
//  TiltShooting
//
//  Created by yirui zhang on 9/17/12.
//  
//
//

#import <Foundation/Foundation.h>
#import "Enemy.h"
#import "Aim.h"
#import "WeaponBase.h"
#import "CoreEventListener.h"

typedef enum {
    RUNNING,
    PAUSING,
    STOPPED
} STATUS;

typedef enum {
    TYPE_UNKNOWN,
    TYPE_AIM,
    TYPE_ENEMY,
    TYPE_TIME_MINUS,
    TYPE_TIME_PLUS,
    TYPE_BULLET_BOX,
    TYPE_MONSTER,
    TYPE_SPIDER,
    TYPE_VAMPIRE
}TYPE_TARGET;

@protocol ModelInterface <NSObject>

@required
+ (id) instance;
+ (TYPE_TARGET) targetType: (Target* )target;

- (void) addToCoreEventListenerList: (id<CoreEventListener>) listener;
- (void) addToCoreEventListenerlist: (id<CoreEventListener>) listener
                           priority: (int) priority;
- (void) removeCoreEventListener: (id<CoreEventListener>) listener;
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
- (void) specialShoot;

/* Data Access Interface */
- (NSMutableArray *) targetList;
- (NSMutableArray *) weaponList;
- (Aim *) aim;
- (float) canvasX;
- (float) canvasY;
- (float) canvasW;
- (float) canvasH;
- (float) deviceW;
- (float) deviceH;
- (float) volume;
- (float) score;
- (float) bonus;
- (NSTimeInterval) remainTime;
- (NSTimeInterval) maxTime;
- (WeaponBase *) currentWeapon;
- (void) setVolume: (float)volume;
- (void) setCanvasX: (float) cx Y: (float) cy;
- (void) setCanvasWidth: (float) cw height: (float) ch;
- (void) setDeviceWidth: (float) dw height: (float)  dh;
- (void) switchToNextWeapon;
- (void) switchToPreviousWeapon;
- (int) combo;
/* Game Control */

/* Conf. */
- (int) hasRecord;

/* debug */
- (void) enableDebug;
- (void) disableDebug;
- (BOOL) debug;
@end
