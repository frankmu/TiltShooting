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
        self.depotRemain = depRemain;
        self.bulletRemain = 0;
        [self doReload];
        self.mana = 0.0f;
    }
    return self;
}

- (void) doReload {
    if (![self canReload]) {
        return;
    }
    
    int bullet = (self.bulletCapacity - self.bulletRemain);
    bullet = bullet > self.depotRemain ? self.depotRemain : bullet;
    self.depotRemain -= bullet;
    self.bulletRemain += bullet;
}

- (void) reload {
    [self doReload];
    id<ModelFullInterface> m = [Model instance];
    [m fireWeaponStatusChangeEvent: self];
}

- (void) shootWithX: (float)x y: (float)y {
    if ([self canShoot]) {
        [self doShootWithX:x y:y];
        id<ModelFullInterface> m = [[Model class] instance];
        [m fireWeaponStatusChangeEvent:self];
    }
}

- (void) specialSkillWithX: (float)x y: (float)y {
    if ([self canUseSpecialShill]) {
        [self doSpecialSkillWithX:x y:y];
        [self setMana:self.mana - self.skillMana];
        
        id<ModelFullInterface> m = [[Model class] instance];
        [m fireWeaponStatusChangeEvent:self];
    }
}

- (void) increaseManaByBonus:(float)bonus {
    id<ModelFullInterface> m = [[Model class] instance];
    self.mana += bonus;
    [m fireWeaponStatusChangeEvent:self];
}

- (BOOL) canUseSpecialShill {
    return self.mana >= self.skillMana;
}

- (BOOL) canShoot {
    return self.bulletRemain > 0;
}

- (BOOL) canReload {
    return self.depotRemain > 0;
}

- (void) doSpecialSkillWithX:(float)x y:(float)y {
    // nothing
}

- (void) doShootWithX:(float)x y:(float)y {
    // nothing
}

@end
