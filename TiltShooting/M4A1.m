//
//  M4A1.m
//  TiltShooting
//
//  Created by yirui zhang on 11/13/12.
//
//

#import "M4A1.h"
#import "Model.h"
#define SPECIAL_SHOOT_RANGE 200.f
#define SPECIAL_SHOOT_SR 10000.f
@implementation M4A1

- (id) init {
    if (self = [super initWithSpeed:0.1f damage:8.0f
                          skillMana:100.0f bulletCapacity:30 depotRemain: 210]) {
        // do nothing
    }
    return self;
}

- (BOOL) doSpecialSkillWithX:(float)x y:(float)y {
    
    // need to find targets in a range
    
    id<ModelFullInterface> m = [[Model class] instance];
    Map2Box2D *p = [m map2Box2D];
    NSMutableArray* array = [p locateRangeTargetX:x y:y :SPECIAL_SHOOT_RANGE
                                                 :SPECIAL_SHOOT_RANGE];
    BOOL hitHappen = NO;
    float srr = SPECIAL_SHOOT_SR;
    self.bulletRemain -= 1;
    for (Target *t in array) {
        float tx = t.x;
        float ty = t.y;
        float sdistance = (x - tx) * (x - tx) + (y - ty) * (y - ty);
        sdistance = sdistance <= 50 ? 50 : sdistance;
        sdistance = sdistance > 1250 ? 1250 : sdistance;
        float rate = sqrtf(srr / sdistance);
        [t onShootBy:self with:^(WeaponBase* weapon, Target* target){
            target.hp -= weapon.damage * ((float)[m combo] / 8.f + 1.f) * rate;
        }];
        hitHappen = YES;
    }
    return hitHappen;
}

- (BOOL) doShootWithX:(float)x y:(float)y {
    id<ModelFullInterface> m = [[Model class] instance];
    
    // search for the targets
    Map2Box2D *p = [m map2Box2D];
    Target *t = [p locateTargetByX:x y:y];
    self.bulletRemain -= 1;
    
    [t onShootBy:self with:^(WeaponBase* weapon, Target* target){
        target.hp -= weapon.damage * (1.f + ((float)[m combo]) / 10.f);
    }];
    return t != nil;
}

- (NSString*) description {
    return @"M4A1";
}

@end
