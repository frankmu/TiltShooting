//
//  Vampire.m
//  TiltShooting
//
//  Created by yirui zhang on 12/1/12.
//
//

#import "Vampire.h"
#import "Model.h"
@implementation Vampire
- (id) initWithX:(float)x Y:(float)y level:(float)level {
    float hp = HP(10, 10, level);
    float bonus = BONUS(10, level);
    float size = SIZE_FORWARD(level);
    if (self = [super initWithX:x Y:y width:size height:size hp:hp bonus:bonus]) {
        self.number = 0;
    }
    return self;
}

- (void) absorb:(Target *)target {
    self.bonus += target.bonus;
    self.hp += target.hp;
    self.width += SIZE_PER_LEVEL;
    self.height += SIZE_PER_LEVEL;
    ++ self.number;
    [[Model instance] fireTargetResizeEvent:self];
}
@end
