//
//  Shape.m
//  TiltShooting
//
//  Created by yirui zhang on 9/25/12.
//
//

#import "Shape.h"

@implementation Shape
@synthesize x = _x, y = _y;

- (id) init {
    return [self initWithX:0.f Y:0.f];
}

- (id) initWithX:(float)x Y:(float)y {
    if (self = [super init]) {
        [self setX:x Y:y];
    }
    return self;
}

- (BOOL) overlap:(Shape *)anotherShape {
    return [self isEqual:anotherShape];
}

- (double) distance:(Shape *)anotherShape {
    double dx = (self.x - anotherShape.x);
    double dy = (self.y - anotherShape.y);
    return sqrt(dx * dx + dy * dy);
}

- (void) setX:(float)x Y:(float)y {
    self.x = x;
    self.y = y;
}

- (NSUInteger) hash {
    NSUInteger hash = 0;
    hash += 11 * self.x;
    hash += 11 * self.y;
    return hash;
}

- (BOOL) isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![super isEqual:object]) {
        return NO;
    }
    
    Shape *other = (Shape *) object;
    return self.x == other.x && self.y == other.y;
}

@end
