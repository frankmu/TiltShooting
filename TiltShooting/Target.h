//
//  Target.h
//  TiltShooting
//
//  Created by yirui zhang on 9/17/12.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WeaponBase.h"

typedef enum {
    TARGET_NORMAL,
    TARGET_FREEZE
}TARGET_STATUS;

@class Target;
typedef void (^bulletBlock)(WeaponBase*, Target*);

@interface Target : NSObject {
    @public
    void *box2dAux;
}

@property (atomic)float x;
@property (atomic)float y;
@property (atomic)float width;
@property (atomic)float height;

@property (atomic)float hp;
@property (atomic)float maxHp;
@property (atomic)float bonus;
@property (atomic)TARGET_STATUS status;
@property (atomic, strong) id aux;
@property (atomic, weak) id intervalAux;

- (id) init;
- (id) initWithX:(float)x Y:(float)y width: (float)width height: (float)height
              hp: (float)hp bonus:(float)bonus;
- (float) xInDevice;
- (float) yInDevice;
- (BOOL) onShootBy: (WeaponBase *)weapon with: (bulletBlock) bullet;
@end
