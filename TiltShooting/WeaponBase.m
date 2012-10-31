//
//  WeaponBase.m
//  TiltShooting
//
//  Created by yirui zhang on 10/30/12.
//
//

#import "WeaponBase.h"
#import "Model.h"

@implementation WeaponBase
@synthesize speed = _speed, mana = _mana, price = _price;
@synthesize bulletCapacity = _bulletCapacity, damage = _damage;
@synthesize bulletRemain = _bulletRemain;
@synthesize skillMana = _skillMana;
@synthesize aux = _aux;

- (id) init {
    return [self initWithSpeed:0.1f damage:1.0f
                     skillMana:0.0f price:10.0f bulletCapacity:100];
}

- (id) initWithSpeed:(float)speed damage:(float)damage
           skillMana:(float)skillMana price:(float)price
      bulletCapacity:(float)cap {
    if (self = [super init]) {
        self.speed = speed;
        self.damage = damage;
        self.skillMana = skillMana;
        self.price = price;
        self.bulletCapacity = cap;
        self.bulletRemain = self.bulletCapacity;
        self.mana = 0.0f;
    }
    return self;
}

- (void) reload {
    self.bulletRemain = self.bulletCapacity;
}

- (void) shootWithX: (float)x y: (float)y {
    if (self.bulletRemain <= 0) {
        return;
    }
    
    id<ModelFullInterface> m = [[Model class] instance];
    // search for the targets
    Map2Box2D *p = [m map2Box2D];
    Target *t = [p locateTargetByX:x y:y];
    self.bulletRemain -= 1;
    [t onShoot:self];
}

- (void) specialSkillWithX: (float)x y: (float)y {
    // no special skill
}

- (void) increaseManaByBonus:(float)bonus {
    id<ModelFullInterface> m = [[Model class] instance];
    self.mana += bonus;
    [m fireWeaponStatusChangeEvent:self];
}

@end
