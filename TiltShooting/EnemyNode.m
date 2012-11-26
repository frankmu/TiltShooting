//
//  EnemyNode.m
//  TiltShootingModel
//
//  Created by yirui zhang on 11/17/12.
//
//

#import "EnemyNode.h"

@implementation EnemyNode

- (void) draw {
    [super draw];
    CGSize size = self.contentSize;
    float rate = self.target.hp / self.target.maxHp;
    glLineWidth(6.0f);
    ccDrawColor4F(1.f, 1.f, 1.f, 1.f);
    ccDrawRect(ccp(0, 0), ccp(size.width, size.height));
    glLineWidth(2.0f);
    ccDrawSolidRect(ccp(1, 1), ccp(size.width - 1, (size.height - 1) * rate),
                    ccc4f(1.f - rate, rate, 0.f, 1.0f));
}

@end
