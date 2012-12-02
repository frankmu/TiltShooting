//
//  PeaceKeeper.m
//  TiltShooting
//
//  Created by yirui zhang on 12/1/12.
//
//

#import "PeaceKeeper.h"
#import "Model.h"

#define SHOOT_RANGE 150.f

@implementation PeaceKeeper
- (id) init {
    if (self = [super initWithSpeed:1.0f damage:5.0f
                          skillMana:100.0f bulletCapacity:7 depotRemain: 63]) {
        // do nothing
    }
    return self;
}

- (BOOL) doSpecialSkillWithX:(float)x y:(float)y {
    id<ModelFullInterface> m = [[Model class] instance];
    Map2Box2D *p = [m map2Box2D];
    NSMutableArray* array = [p locateRangeTargetX:x y:y :SHOOT_RANGE
                                                 :SHOOT_RANGE];
    Target* theOne = nil;
    float smin = SHOOT_RANGE * SHOOT_RANGE;
    for (Target *t in array) {
        float tx = t.x;
        float ty = t.y;
        int distance = (tx - x) * (tx - x) + (ty - y) * (ty - y);
        if (distance < smin) {
            theOne = t;
            smin = distance;
        }// if
    }// for
    
    if (theOne != nil) {
        [theOne onShootBy:self with:^(WeaponBase* weapon, Target* target){
            target.hp -= target.hp + 10.f; // died for sure
        }];
        return YES;
    }
    return NO;
}

- (BOOL) doShootWithX:(float)x y:(float)y {
    id<ModelFullInterface> m = [[Model class] instance];
    Map2Box2D *p = [m map2Box2D];
    NSMutableArray* array = [p locateRangeTargetX:x y:y :SHOOT_RANGE
                                                 :SHOOT_RANGE];
    BOOL hitHappen = NO;
    self.bulletRemain -= 1;
    int totalNumber = arc4random() % 10 + 5;
    for (Target *t in array) {
        int number = totalNumber <= 2 ? 1 : arc4random() % totalNumber;
        totalNumber -= number;
        [t onShootBy:self with:^(WeaponBase* weapon, Target* target){
            target.hp -= weapon.damage * number;
        }];
        hitHappen = YES;
    }
    return hitHappen;
}

- (NSString*) description {
    return @"PeaceKeeper";
}

@end
