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


@interface Target : NSObject {
    @public
    void *box2dAux;
}

@property float x;
@property float y;

@property float hp;
@property float bonus;
@property TARGET_STATUS status;
@property (weak) id aux;
@property (weak) id intervalAux;

- (id) init;
- (id) initWithX: (float)x Y: (float)y;
- (id) initWithX:(float)x Y:(float)y hp: (float)hp bonus:(float)bonus;
- (float) xInDevice;
- (float) yInDevice;
- (void) onShoot: (WeaponBase *)weapon;
@end
