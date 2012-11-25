//
//  CBTarget.h
//  TiltShooting
//
//  Created by yan zhuang on 12-11-24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCBAnimationManager.h"
@interface CBTarget : CCNode<CCBAnimationManagerDelegate> {
    
}
@property (nonatomic,strong) CCBAnimationManager* animationManager;
@end
