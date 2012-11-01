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
- (BUBBLE_RULE) impact: (Target *)target by: (Target *)target;
- (BUBBLE_RULE) prepareToDisappear: (Target *)target;
/* weapon */
- (BUBBLE_RULE) weaponStatusChanged:(WeaponBase *)weapon;
/* other object */
- (BUBBLE_RULE) canvasMovetoX: (float)x Y: (float)y;

/* game control signals */
- (BUBBLE_RULE) gameInitFinished;
//- (BUBBLE_RULE) win;
//- (BUBBLE_RULE) lose;
- (BUBBLE_RULE) gameFinish;
- (BUBBLE_RULE) score: (float)score;
- (BUBBLE_RULE) time: (float)time;
//- (BUBBLE_RULE) bonus: (float)bonus;
@end
