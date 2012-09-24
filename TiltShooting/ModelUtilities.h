//
//  ModelUtilities.h
//  TiltShooting
//
//  Created by yirui zhang on 9/18/12.
//
//

#import <Foundation/Foundation.h>

@interface ModelUtilities : NSObject

+ (float) d2cX: (float) xInDevice;
+ (float) d2cY: (float) yInDevice;
+ (float) c2dX: (float) xInCanvas;
+ (float) c2dY: (float) yInCanvas;

@end
