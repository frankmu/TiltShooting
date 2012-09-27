//
//  Shape.h
//  TiltShooting
//
//  Created by yirui zhang on 9/25/12.
//
//

#import <Foundation/Foundation.h>

@interface Shape : NSObject
// by default, the x and y are the positions in canvas coordinate
// please use *InDevice (* is "x" or "y") to get the position in device
@property float x;
@property float y;

- (id) init;
- (id) initWithX: (float)x Y: (float)y;
- (BOOL) overlap: (Shape *) anotherShape;
- (double) distance: (Shape *) anotherShape;
- (void) setX: (float)x Y: (float)y;

@end
