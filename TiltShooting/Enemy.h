//
//  Enemy.h
//  TiltShooting
//
//  Created by yirui zhang on 9/17/12.
//
//

#import <Foundation/Foundation.h>
#import "Target.h"

@interface Enemy : Target

- (id) initWithX:(float)x Y:(float)y hp: (float)hp;
@end
