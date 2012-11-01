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
@synthesize speed = _speed, mana = _mana, damage = _damage;
@synthesize bulletCapacity = _bulletCapacity;
@synthesize bulletRemain = _bulletRemain;
@synthesize depotRemain = _depotRemain;
@synthesize skillMana = _skillMana;
@synthesize aux = _aux;

- (id) init {
    return [self initWithSpeed:0.1f damage:1.0f
                     skillMana:0.0f bulletCapacity:5 depotRemain:100];
}

- (id) initWithSpeed:(float)speed damage:(float)damage
           skillMana:(float)skillMana bulletCapacity:(int)cap
            depotRemain:(int)depRemain{
    if (self = [super init]) {
        self.speed = speed;
        self.damage = damage;
        self.skillMana = skillMana;
        self.bulletCapacity = cap;
        self.bulletRemain = self.bulletCapacity;
        self.depotRemain = depRemain;
        self.mana = 0.0f;
    }
    return self;
}

- (void) reload {
    id<ModelFullInterface> m = [[Model class] instance];
    int bullet = (self.bulletCapacity - self.bulletRemain);
    bullet = bullet > self.depotRemain ? self.depotRemain : bullet;
    self.depotRemain -= bullet;
    self.bulletRemain += bullet;
    [m fireWeaponStatusChangeEvent:self];
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
    [m fireWeaponStatusChangeEvent:self];
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
