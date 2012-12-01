//
//  BulletBox.m
//  TiltShooting
//
//  Created by yirui zhang on 11/30/12.
//
//

#import "BulletBox.h"
#import "Model.h"

@implementation BulletBox

- (id) initWithX:(float)x Y:(float)y level:(float)level {
    float bullet = level * 10 + 10;
    float size = SIZE_BACKWARD(level);
    if (self = [super initWithX:x Y:y width:size height:size hp:1 bonus:0]) {
        self.bullet = bullet;
    }
    return self;
}

- (BOOL) onShootBy:(WeaponBase *)weapon with:(bulletBlock)bullet {
    bullet(weapon, self);
    
    id<ModelFullInterface> m = [[Model class] instance];
    weapon.depotRemain += self.bullet;
    [m deleteTarget:self];
    return YES;
}

- (NSString *) description {
    return [NSString stringWithFormat:@"BulletBox%@", [super description]];
}
@end
