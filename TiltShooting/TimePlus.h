//
//  TimePlus.h
//  TiltShootingModel
//
//  Created by yirui zhang on 11/16/12.
//
//

#import "Target.h"

@interface TimePlus : Target
@property (atomic) float time;
- (id)initWithX:(float)x Y:(float)y level:(float)level;
@end
