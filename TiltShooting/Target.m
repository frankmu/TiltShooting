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
@synthesize hp = _hp, maxHp = _maxHp, bonus = _bonus;

- (id) init {
    return [self initWithX:0.f Y:0.f width:10.f height:10.f hp:1.f bonus:0.f];
}

- (id) initWithX:(float)x Y:(float)y width:(float)width height:(float)height
              hp: (float)hp bonus:(float)bonus {
    if (self = [super init]) {
        self.x = x;             
        self.y = y;
        self.width = width;
        self.height = height;
        self.aux = nil;
        self.hp = hp;
        self.maxHp = hp;
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

- (BOOL) onShootBy:(WeaponBase *)weapon with:(bulletBlock)bullet {
    // nothing
    return NO;
}

- (NSString*) description {
    return [NSString stringWithFormat:@"[hp:%f, bonus:%f] @ [%f, %f]",
            self.hp, self.bonus, self.x, self.y];
}
@end
