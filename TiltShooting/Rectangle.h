//
//  Rectangle.h
//  TiltShooting
//
//  Created by yirui zhang on 9/25/12.
//
//

#import <Foundation/Foundation.h>
#import "Shape.h"

@interface Rectangle : Shape

@property float height;
@property float width;

- (id) init;
- (id) initWithX: (float)x Y: (float)y width: (float)width height: (float)height;
- (void) setWidth: (float)width height: (float)height;
- (BOOL) overlap:(Shape *)anotherShape;
@end
