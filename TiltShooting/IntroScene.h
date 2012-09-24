//
//  IntroScene.h
//  TiltShooting
//
//  Created by yan zhuang on 12-9-17.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "IntroLayer.h"
@interface IntroScene : CCScene {
    
}

@property (nonatomic, strong) IntroScene *introScene;
@property (nonatomic, strong) IntroLayer *introLayer;
+(id) ShowScene;
@end
