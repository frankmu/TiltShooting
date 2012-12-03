//
//  AppDelegate.h
//  TiltShooting
//
//  Created by yirui zhang on 9/18/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <FacebookSDK/FacebookSDK.h>
#import "Facebook.h"
#import "cocos2d.h"
#import "Model.h"
#import "ShakeEnabledUIWindow.h"
//#import "GameOverScene.h"
@class GameOverScene;

extern NSString *const FBSessionStateChangedNotification;

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
	UIWindow *window_;
    //ShakeEnabledUIWindow *window_;
	UINavigationController *navController_;
	
	CCDirectorIOS	*director_;							// weak ref
    Model *model_;
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;
@property (readonly) Model *model;
@property NSString *flag;
@property GameOverScene *layer;

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (void) closeSession;

@end
