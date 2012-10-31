//
//  ModelUtilities.h
//  TiltShooting
//
//  Created by yirui zhang on 9/18/12.
//
//

#import <Foundation/Foundation.h>
#define DEBUG_INTERVAL (1.0)
typedef struct {
    float left;
    float right;
    float top;
    float bottom;
} WALLS, WALL_GAP;

@interface ModelUtilities : NSObject
+ (WALLS) devWallsInCanvasByAim;
+ (WALLS) canvasWallsInDev;
+ (float) d2cX: (float) xInDevice;
+ (float) d2cY: (float) yInDevice;
+ (float) c2dX: (float) xInCanvas;
+ (float) c2dY: (float) yInCanvas;
+ (float) radian2degree: (float) radian;
+ (float) degree2radian: (float) degree;
+ (BOOL) debugDetect: (NSUInteger)runningTimes
            interval: (NSTimeInterval)interval;
+ (void) debug: (id)msg, ...;
+ (void) debugWithDetect: (NSUInteger)runningTimes
                interval: (NSTimeInterval)interval
                 format: (id)msg, ...;
@end
