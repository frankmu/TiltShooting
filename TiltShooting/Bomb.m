//
//  Bomb.m
//  TiltShooting
//
//  Created by yirui zhang on 9/18/12.
//
//

#import "Bomb.h"
#import "Model.h"

@implementation Bomb

- (id) initWithX:(float)x Y:(float)y {
    if (self = [super initWithX:x Y:y hp:1.0f bonus:0.0f]) {
        // nothing
    }
    return self;
}

- (void) onShoot:(WeaponBase *)weapon {
    id<ModelFullInterface> m = [[Model class] instance];
    [m changeTime:[m time] - 10.0f];
    [m deleteTarget:self];
}

@end
