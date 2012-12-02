//
//  GameOverScene.h
//  TiltShooting
//
//  Created by yan zhuang on 12-9-17.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <FacebookSDK/FacebookSDK.h>
#import "Facebook.h"
#import "cocos2d.h"
#import "MenuScene.h"
#import "MainScene.h"
#import "AppDelegate.h"
@interface GameOverScene : CCScene<FBDialogDelegate>{
    
}
@property(nonatomic,strong) CCSprite *background;
@property BOOL win;
@property float score;
@property float time;
@property (strong, nonatomic) NSMutableDictionary *postParams;
@property (strong, nonatomic) Facebook *facebook;
@property(nonatomic,strong) AppController *appDelegate;
-(id)start;
@end
