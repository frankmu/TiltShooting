//
//  SpecialEffectNode.m
//  TiltShootingModel
//
//  Created by yirui zhang on 11/16/12.
//
//

#import "SpecialEffectNode.h"
@interface SpecialEffectNode()
@property float inc;
@end

@implementation SpecialEffectNode

- (id) initWithTarget:(Target *)t {
    if (self = [super initWithTarget:t]) {
        self.inc = 0.f;
        [self scheduleUpdate];
    }
    return self;
}

-(void) update:(ccTime)deltaTime {
    self.inc += deltaTime * 4;
    if (self.inc > 5) {
        self.inc = 0;
    }
}

- (void) draw {
    [super draw];
    
    CGSize size = self.contentSize;
    glLineWidth(2.0f);
    ccDrawColor4B(255, 255, 0, 255);
    ccDrawRect(ccp(- self.inc,
                   - self.inc),
               ccp(size.width + self.inc,
                   size.height + self.inc));
}

@end
