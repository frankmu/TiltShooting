//
//  BulletBox.h
//  TiltShooting
//
//  Created by yirui zhang on 11/30/12.
//
//

#import "Target.h"

@interface BulletBox : Target
@property (atomic) int bullet;
- (id) initWithX:(float)x Y:(float)y level:(float)level;
@end
