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

+ (WALLS) devWallsInCanvasByAim {
    Model *m = [[Model class] instance];
    WALLS walls = {0.f, 0.f, 0.f, 0.f};
    walls.left = m.aim.x - 0.5 * m.deviceW;
    walls.right = m.aim.x + 0.5 * m.deviceW;
    walls.top = m.aim.y + 0.5 * m.deviceH;
    walls.bottom = m.aim.y - 0.5 * m.deviceH;
    return walls;
}

+ (WALLS) canvasWallsInDev {
    WALLS walls = {0.f, 0.f, 0.f, 0.f};
    walls.left = [[ModelUtilities class] canvasLeftWall];
    walls.right = [[ModelUtilities class] canvasRightWall];
    walls.top = [[ModelUtilities class] canvasTopWall];
    walls.bottom = [[ModelUtilities class] canvasBottomWall];
    return walls;
}

+ (float) canvasLeftWall {
    Model *m = [[Model class] instance];
    return m.canvasX - 0.5f * m.canvasW;
}

+ (float) canvasRightWall {
    Model *m = [[Model class] instance];
    return m.canvasX + 0.5f * m.canvasW;
}

+ (float) canvasBottomWall {
    Model *m = [[Model class] instance];
    return m.canvasY - 0.5f * m.canvasH;
}

+ (float) canvasTopWall {
    Model *m = [[Model class] instance];
    return m.canvasY + 0.5f * m.canvasH;
}

+ (float) d2cX:(float)xInDevice {
    return xInDevice - [[ModelUtilities class] canvasLeftWall];
}

+ (float) d2cY:(float)yInDevice {
    return yInDevice - [[ModelUtilities class] canvasBottomWall];
}

+ (float) c2dX:(float)xInCanvas {
    return xInCanvas + [[ModelUtilities class] canvasLeftWall];
}

+ (float) c2dY:(float)yInCanvas {
    return yInCanvas + [[ModelUtilities class] canvasBottomWall];
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
