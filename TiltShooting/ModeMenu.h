//
//  ModeMenu.h
//  TiltShooting
//
//  Created by yan zhuang on 12-11-28.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AppDelegate.h"
@interface ModeMenu : CCLayer {
    
}
@property(nonatomic,strong) CCSprite *background;
@property(nonatomic,strong) NSMutableArray *spriteArray;
@property(nonatomic,strong) NSMutableArray *imageArray;
@property(nonatomic,strong) CCNode* facebookMenu;
//@property(nonatomic,strong) CCSprite* facebookBg;
@property(nonatomic,strong) CCNode* loading;
@property(nonatomic,strong) CCNode* prompt;
@property(nonatomic,strong) CCMenu* modeMenuButtons;
@property(nonatomic,strong) CCMenu* fbMenuButtons;
@property(nonatomic,strong) AppController *appDelegate;
@end
