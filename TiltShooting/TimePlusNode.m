//
//  TimePlus.m
//  TiltShootingModel
//
//  Created by yirui zhang on 11/16/12.
//
//

#import "TimePlusNode.h"

@implementation TimePlusNode

- (void) draw {
    [super draw];
    CGSize size = self.contentSize;
    float xr = 0.5 * size.width;
    float yr = 0.5 * size.height;
    float x = anchorPointInPoints_.x;
    float y = anchorPointInPoints_.y;
    ccDrawSolidRect(ccp(0, 0),
                    ccp(size.width, size.height),
                    ccc4f(1.f, 1.f, 1.f, 1.f));
    glLineWidth(4.0);
    ccDrawColor4B(255, 0, 0, 255);
    xr = 0.4 * size.width;
    yr = 0.4 * size.height;
    ccDrawLine(ccp(x, y - yr), ccp(x, y + yr));
    ccDrawLine(ccp(x - xr, y), ccp(x + xr, y));
}
@end
