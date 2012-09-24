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

@synthesize x = _x;
@synthesize y = _y;
@synthesize aux = _aux;

- (id) initWithPositionX:(float)x Y:(float)y {
    return [self initWithPositionX:x Y:y Aux:nil];
}

- (id) initWithPositionX:(float)x Y:(float)y Aux:(id)aux {
    if (self = [super init]) {
        self.x = x;
        self.y = y;
        self.aux = aux;
    }
    return self;
}

- (id) init {
    return [self initWithPositionX:0.0 Y:0.0];
}

- (float) xInDevice {
    return [[ModelUtilities class] c2dX:self.x];
}

- (float) yInDevice {
    return [[ModelUtilities class] c2dY:self.y];
}

@end
