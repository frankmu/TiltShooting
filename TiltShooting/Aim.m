//
//  Aim.m
//  TiltShooting
//
//  Created by yirui zhang on 9/17/12.
//
//

#import "Aim.h"

@implementation Aim

- (id) initWithX: (float)x Y: (float)y {
    if (self = [super initWithX:x Y:y width:10.f height:10.f hp:1.f bonus:0.f]) {
        // nothing
    }
    return self;
}

- (BOOL)onShoot: (float) damage {
    // [important] do nothing, aim should not in the target list
    return NO;
}

@end
