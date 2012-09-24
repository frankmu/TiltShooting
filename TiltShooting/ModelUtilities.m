//
//  ModelUtilities.m
//  TiltShooting
//
//  Created by yirui zhang on 9/18/12.
//
//

#import "ModelUtilities.h"
#import "Model.h"

@implementation ModelUtilities

+ (float) d2cX:(float)xInDevice {
    Model *m = [[Model class] instance];
    xInDevice -= m.canvasX;
    return xInDevice;
}

+ (float) d2cY:(float)yInDevice {
    Model *m = [[Model class] instance];
    yInDevice -= m.canvasY;
    return yInDevice;
}
+ (float) c2dX:(float)xInCanvas {
    Model *m = [[Model class] instance];
    xInCanvas += m.canvasX;
    return xInCanvas;
}
+ (float) c2dY:(float)yInCanvas {
    Model *m = [[Model class] instance];
    yInCanvas += m.canvasY;
    return yInCanvas;
}


@end
