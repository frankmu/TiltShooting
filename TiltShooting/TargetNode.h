//
//  TargetNode.h
//  TiltShootingModel
//
//  Created by yirui zhang on 11/15/12.
//
//

#import "cocos2d.h"
#import "Model.h"

@interface TargetNode : CCNode
@property (weak, nonatomic) Target* target;

- (id) initWithTarget: (Target *)t;
@end
