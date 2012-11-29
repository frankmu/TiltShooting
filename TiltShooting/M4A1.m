//
//  M4A1.m
//  TiltShooting
//
//  Created by yirui zhang on 11/13/12.
//
//

#import "M4A1.h"
#import "Model.h"
@implementation M4A1

- (id) init {
    if (self = [super initWithSpeed:0.1f damage:10.0f
                          skillMana:100.0f bulletCapacity:30 depotRemain: 210]) {
        // do nothing
    }
    return self;
}

- (BOOL) doSpecialSkillWithX:(float)x y:(float)y {
    
    // need to find targets in a range
    
    id<ModelFullInterface> m = [[Model class] instance];
    Map2Box2D *p = [m map2Box2D];
    NSMutableArray* array = [p locateRangeTargetX:x y:y :240 :160];
    BOOL hitHappen = NO;
    for (Target *t in array) {
        if ([self canShoot]) {
            self.bulletRemain -= 1;
            [t onShootBy:self with:^(WeaponBase* weapon, Target* target){
                target.hp -= weapon.damage * 5;
            }];
            hitHappen = YES;
        } else {
            break;
        }
    }
//    self.bulletRemain -= 1;
//    
//    [t onShootBy:self with:^(){
//        t.hp -= self.damage * 10;
//    }];
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
