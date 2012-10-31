//
//  Target.m
//  TiltShooting
//
//  Created by yirui zhang on 9/17/12.
//
//

#import "Target.h"
#import "ModelUtilities.h"

@interface Target()

@end

@implementation Target

@synthesize aux = _aux, intervalAux = _intervalAux;
@synthesize x = _x, y = _y;
@synthesize status = _status;
@synthesize hp = _hp, bonus = _bonus;

- (id) init {
    return [self initWithX:0.f Y:0.f];
}

- (id) initWithX:(float)x Y:(float)y {
    return [self initWithX:x Y:y hp:1 bonus:1];
}

- (id) initWithX:(float)x Y:(float)y hp: (float)hp bonus:(float)bonus {
    if (self = [super init]) {
        self.x = x;
        self.y = y;
        self.aux = nil;
        self.hp = hp;
        self.bonus = bonus;
        self.status = TARGET_NORMAL;
    }
    return self;
}

- (float) xInDevice {
    return [[ModelUtilities class] c2dX:self.x];
}

- (float) yInDevice {
    return [[ModelUtilities class] c2dY:self.y];
}

- (void) onShoot:(WeaponBase *)weapon {
}

@end
