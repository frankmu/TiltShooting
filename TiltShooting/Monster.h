//
//  Monster.h
//  TiltShooting
//
//  Created by yirui zhang on 11/30/12.
//
//

#import "Target.h"
#import "Enemy.h"
@interface Monster : Enemy
@property (nonatomic) NSTimeInterval time;
- (id) initWithX:(float)x Y:(float)y level:(float) level;
@end
