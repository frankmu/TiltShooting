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

@protocol CoreEventListener <NSObject>

@optional
/* target */
- (int) targetAppear: (Target *) target;
- (int) targetDisAppear: (Target *) target;
- (int) targetMove: (Target *) target;

/* other object */
- (int) canvasMovetoX: (float) x Y: (float) y;
- (int) impact: (Target *) target by: (Target *) target;

/* game control signals */
- (int) gameInitFinished;
@end
