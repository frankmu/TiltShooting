//
//  Rectangle.m
//  TiltShooting
//
//  Created by yirui zhang on 9/25/12.
//
//

#import "Rectangle.h"

@implementation Rectangle
@synthesize width = _width, height = _height;

- (id) init {
    return [self initWithX:0.f Y:0.f width:40.f height:40.f];
}

- (id) initWithX:(float)x Y:(float)y width:(float)width height:(float)height {
    if (self = [super initWithX:x Y:y]) {
        [self setWidth:width height:height];
    }
    return self;
}

- (void) setWidth:(float)width height:(float)height {
    self.width = width;
    self.height = height;
}

- (BOOL) overlap:(Shape *)anotherShape {
    return NO;
}
@end
