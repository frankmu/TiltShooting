//
//  TimeMinusNode.m
//  TiltShootingModel
//
//  Created by yirui zhang on 11/16/12.
//
//

#import "TimeMinusNode.h"

@implementation TimeMinusNode

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
    glLineWidth(6.0);
    ccDrawColor4B(0, 51, 153, 255);
    xr = 0.4 * size.width;
    yr = 0.4 * size.height;
    ccDrawLine(ccp(x - xr, y), ccp(x + xr, y));
}
@end
