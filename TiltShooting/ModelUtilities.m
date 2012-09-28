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

+ (float) radian2degree:(float)radian {
    return radian * 180.f / M_PI;
}

+ (float) degree2radian:(float)degree {
    return degree * M_PI / 180.f;
}

+ (BOOL) debugDetect:(NSUInteger)runningTimes interval:(NSTimeInterval)interval {
    id<ModelInterface> model = [[Model class] instance];
    if (!interval) {
        return NO;
    }
    return model.debug && !(runningTimes % (NSInteger)ceil(DEBUG_INTERVAL / interval));
}

+ (void) debugWithDetect:(NSUInteger)runningTimes
                interval:(NSTimeInterval)interval
                  format:(id)msg, ... {
    if (![[ModelUtilities class] debugDetect:runningTimes interval:interval]) {
        return;
    } else {
        va_list args;
        va_start(args, msg);
        NSLogv(msg, args);
        va_end(args);
    }
}

+ (void) debug:(id)msg, ... {
    id<ModelInterface> model = [[Model class] instance];
    if (!model.debug) {
        return;
    }
    va_list args;
    va_start(args, msg);
    NSLogv(msg, args);
    va_end(args);
}

@end
