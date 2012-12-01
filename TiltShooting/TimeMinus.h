//
//  TimeMinus.h
//  TiltShootingModel
//
//  Created by yirui zhang on 11/16/12.
//
//

#import "Target.h"

@interface TimeMinus : Target
@property (atomic) float time;

- (id)initWithX:(float)x Y:(float)y level:(float) level;
@end
