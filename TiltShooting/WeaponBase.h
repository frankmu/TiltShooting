//
//  WeaponBase.h
//  TiltShooting
//
//  Created by yirui zhang on 10/30/12.
//
//

#import <Foundation/Foundation.h>

typedef enum {
    RELOAD_NO_BULLET,
    RELOAD_NORMAL
}RELOAD_RESULT;

@interface WeaponBase : NSObject
@property (weak) id aux;
@property double speed;
@property float damage;
@property float mana;
@property float skillMana;
@property int bulletCapacity;
@property (atomic) int bulletRemain;
@property (atomic) int depotRemain;

- (id) initWithSpeed: (float)speed damage: (float)damage
           skillMana: (float)skillMana bulletCapacity: (int)cap
         depotRemain:(int)depRemain;

- (void) shootWithX: (float)x y: (float)y ;
- (void) specialSkillWithX: (float)x y: (float)y;
- (void) increaseManaByBonus: (float)bonus;
- (void) reload;
@end
