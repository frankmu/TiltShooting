//
//  Enemy.m
//  TiltShooting
//
//  Created by yirui zhang on 9/17/12.
//
//

#import "Enemy.h"
#import "Model.h"

@interface Enemy()

@end

@implementation Enemy

- (id) initWithX:(float)x Y:(float)y {
    if (self = [super initWithX:x Y:y hp:10.0f bonus:1.0f]) {
        // nothing
    }    
    return self;
}

- (void) onShoot:(WeaponBase *)weapon {
    self.hp -= weapon.damage;
    if (self.hp < 0) {
        id<ModelFullInterface> m = [[Model class] instance];
        [m changeScore:[m score] + self.bonus * 10];
        [m deleteTarget:self];
    }
}

- (NSString *) description {
    return @"Enemy";
}

@end
