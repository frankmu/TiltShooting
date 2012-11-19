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

- (id) initWithX:(float)x Y:(float)y hp:(float)hp{
    float bonus = sqrtf(hp) + hp / 5;
    float size = sqrtf(hp) * 5;
    size = size <= 10 ? 10 : size;
    if (self = [super initWithX:x Y:y width:size height:size hp:hp bonus:bonus]) {
        // nothing
    }    
    return self;
}

- (BOOL) onShootBy:(WeaponBase *)weapon with:(bulletBlock)bullet {
    bullet(weapon, self);
    id<ModelFullInterface> m = [[Model class] instance];
    if (self.hp < 0) {        
        [m changeScore:[m score] + self.bonus * 10];
        [m deleteTarget:self];
        return YES;
    } else {
        [m fireTargetHitEvent: self];
    }
    return NO;
}

- (BOOL) onShoot:(float)damage {

    return NO;
}

- (NSString *) description {
    return [NSString stringWithFormat:@"Enemy%@", [super description]];
}

@end
