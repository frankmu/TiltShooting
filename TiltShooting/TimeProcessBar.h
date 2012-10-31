//
//  TimeProcessBar.h
//  TiltShooting
//
//  Created by yan zhuang on 12-10-20.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@class GameLayer;
@interface TimeProcessBar : CCNode {
    
}
@property (weak) GameLayer* glayer;
@property (nonatomic,strong) CCProgressTimer *ct;
-(id) showTimeBarInLayer:(CCLayer*)layer;
-(void)updateTimeBar:(float)percentage;

@end
