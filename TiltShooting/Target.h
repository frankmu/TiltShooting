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

#define MAX_SIZE 60.f
#define MIN_SIZE 20.f
#define MAX_LEVEL 10.f
#define SIZE_PER_LEVEL ((MAX_SIZE - MIN_SIZE) / MAX_LEVEL)
#define SIZE_FORWARD(level) (level * SIZE_PER_LEVEL + MIN_SIZE)
#define SIZE_BACKWARD(level) (MAX_SIZE - level * SIZE_PER_LEVEL)
#define HP(base, inc, level) (base + inc * level)
#define BONUS(weight, level) (weight * sqrtf(level))
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

@property (atomic) float x;
@property (atomic) float y;
@property (atomic) float width;
@property (atomic) float height;
@property (atomic) NSTimeInterval timer;

@property (atomic) float hp;
@property (atomic) float maxHp;
@property (atomic) float bonus;
@property (atomic) TARGET_STATUS status;
@property (atomic, strong) id aux;
@property (atomic, weak) id intervalAux;

- (id) initWithX:(float)x Y:(float)y level:(float)level;
- (id) init;
- (id) initWithX:(float)x Y:(float)y width: (float)width height: (float)height
              hp: (float)hp bonus:(float)bonus;
- (float) xInDevice;
- (float) yInDevice;
- (BOOL) onShootBy: (WeaponBase *)weapon with: (bulletBlock) bullet;
@end
