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

@synthesize aux = _aux;
@synthesize x = _x, y = _y;

- (id) init {
    return [self initWithX:0.f Y:0.f];
}

- (id) initWithX:(float)x Y:(float)y {
    if (self = [super init]) {
        self.x = x;
        self.y = y;
        self.aux = nil;
    }
    return self;
}

- (float) xInDevice {
    return [[ModelUtilities class] c2dX:self.x];
}

- (float) yInDevice {
    return [[ModelUtilities class] c2dY:self.y];
}

@end
