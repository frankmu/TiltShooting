//
//  WeaponBase.h
//  TiltShooting
//
//  Created by yirui zhang on 10/30/12.
//
//

#import <Foundation/Foundation.h>

@interface WeaponBase : NSObject
@property (weak) id aux;
@property double speed;
@property float damage;
@property float mana;
@property float skillMana;
@property float price;
@property int bulletCapacity;
@property int bulletRemain;

- (id) initWithSpeed: (float)speed damage: (float)damage
           skillMana: (float)skillMana price: (float)price
           bulletCapacity: (float)cap;

- (void) shootWithX: (float)x y: (float)y ;
- (void) specialSkillWithX: (float)x y: (float)y;
- (void) increaseManaByBonus: (float)bonus;
- (void) reload;
@end
