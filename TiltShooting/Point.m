//
//  POINT.m
//  TiltShooting
//
//  Created by yirui zhang on 10/31/12.
//
//

#import "POINT.h"

@implementation POINT
@synthesize x = _x, y = _y, useSkill = _useSkill;

- (id) init {
    return [self initWithX:0.0f y:0.0f useSkill:NO];
}

- (id) initWithX: (float)x y: (float)y useSkill:(BOOL)useSkill{
    if (self = [super init]) {
        self.x = x;
        self.y = y;
        self.useSkill = useSkill;
    }
    return self;
}

@end
