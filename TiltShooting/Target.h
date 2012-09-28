//
//  Target.h
//  TiltShooting
//
//  Created by yirui zhang on 9/17/12.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Shape.h"

@interface Target : NSObject

@property float x;
@property float y;
@property id aux;

- (id) init;
- (id) initWithX: (float)x Y: (float)y;
- (float) xInDevice;
- (float) yInDevice;
@end
