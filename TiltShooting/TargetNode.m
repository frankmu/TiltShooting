//
//  TargetNode.m
//  TiltShootingModel
//
//  Created by yirui zhang on 11/15/12.
//
//

#import "TargetNode.h"

@implementation TargetNode
@synthesize target = _target;

- (id) init {
    return [self initWithTarget:nil];
}

- (id) initWithTarget:(Target *)t {
    if (self = [super init]) {
        self.shaderProgram = [[CCShaderCache sharedShaderCache] programForKey:kCCShader_PositionColor];
        self.anchorPoint = ccp(0.5f, 0.5f);
        self.contentSize = CGSizeMake(t.width, t.height);
        self.position = ccp(t.x, t.y);
        self.target = t;
        [self setVisible:YES];
    }
    return self;
}


@end
