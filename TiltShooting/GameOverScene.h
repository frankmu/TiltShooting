//
//  GameOverScene.h
//  TiltShooting
//
//  Created by yan zhuang on 12-9-17.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MenuScene.h"
#import "MainScene.h"
@interface GameOverScene : CCScene {
    
}
@property(nonatomic,strong) CCSprite *background;
@property BOOL win;
@property float score;
-(id)start;
@end
