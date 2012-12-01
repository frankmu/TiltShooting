//
//  Vampire.h
//  TiltShooting
//
//  Created by yirui zhang on 12/1/12.
//
//

#import "Enemy.h"

@interface Vampire : Enemy
@property (nonatomic) int number;
- (void) absorb: (Target*) target;
@end
