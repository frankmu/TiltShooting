//
//  Target.h
//  TiltShooting
//
//  Created by yirui zhang on 9/17/12.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Target : NSObject

// by default, the x and y are the positions in canvas coordinate
// please use *InDevice (* is "x" or "y") to get the position in device
@property float x;
@property float y;
@property float width;
@property float height;
@property id aux;

- (id) initWithPositionX: (float)x Y: (float)y;
- (id) initWithPositionX: (float)x Y: (float)y Aux: aux;
- (float) xInDevice;
- (float) yInDevice;
@end
