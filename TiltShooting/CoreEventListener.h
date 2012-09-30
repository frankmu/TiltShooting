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
/* other object */
- (BUBBLE_RULE) canvasMovetoX: (float)x Y: (float)y;

/* game control signals */
- (BUBBLE_RULE) gameInitFinished;
@end
