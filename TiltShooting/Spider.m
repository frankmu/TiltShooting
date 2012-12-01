//
//  Spider.m
//  TiltShooting
//
//  Created by yirui zhang on 11/30/12.
//
//

#import "Spider.h"
#import "Model.h"

@implementation Spider
- (id) initWithX:(float)x Y:(float)y level:(float)level {
    float hp = HP(10, 10, level);
    float bonus = BONUS(10, level);
    float size = SIZE_FORWARD(level);
    if (self = [super initWithX:x Y:y width:size height:size hp:hp bonus:bonus]) {
        self.splitNumber = level + 1;
        self.level = level;
    }
    return self;
}

- (BOOL) onShootBy:(WeaponBase *)weapon with:(bulletBlock)bullet {
    BOOL died = [super onShootBy:weapon with:bullet];
    if (died) {
        id<ModelFullInterface> m = [Model instance];
        Map2Box2D* box = [m map2Box2D];
        [box separateTarget:self number:self.splitNumber level:self.level];
    }
    return died;
}

- (NSString *) description {
    return [NSString stringWithFormat:@"Spider%@", [super description]];
}
@end
