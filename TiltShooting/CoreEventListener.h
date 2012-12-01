//
//  CoreEventListener.h
//  TiltShooting
//
//  Created by yirui zhang on 9/17/12.
//
//

#import <Foundation/Foundation.h>
#import "Target.h"
#import "Enemy.h"

typedef enum {
    BUBBLE_CONTINUE,
    BUBBLE_STOP
} BUBBLE_RULE;

@protocol CoreEventListener <NSObject>

@optional
/* target */
- (BUBBLE_RULE) targetAppear: (Target *)target;
- (BUBBLE_RULE) targetDisAppear: (Target *)target;
- (BUBBLE_RULE) targetMove: (Target *)target;
- (BUBBLE_RULE) targetHit: (Target *)target;
- (BUBBLE_RULE) targetResize: (Target *)target;
- (BUBBLE_RULE) prepareToDisappear: (Target *)target time:(NSTimeInterval)time;
- (BUBBLE_RULE) prepareToAppear: (Target *)target time:(NSTimeInterval)time;
/* weapon */
- (BUBBLE_RULE) weaponStatusChanged:(WeaponBase *)weapon;
- (BUBBLE_RULE) needReload;
/* other object */
- (BUBBLE_RULE) canvasMovetoX: (float)x Y: (float)y;

/* game control signals */
- (BUBBLE_RULE) gameInitFinished;
- (BUBBLE_RULE) gameFinish;
- (BUBBLE_RULE) score: (float)score;
- (BUBBLE_RULE) time: (float)time;
- (BUBBLE_RULE) bonus: (float)bonus;

/* new */
- (BUBBLE_RULE) targetMissX: (float)x y:(float)y;
- (BUBBLE_RULE) flushFinish;
@end
