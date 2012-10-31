//
//  TimeProcessBar.m
//  TiltShooting
//
//  Created by yan zhuang on 12-10-20.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "TimeProcessBar.h"
#import "GameLayer.h"

@implementation TimeProcessBar
@synthesize glayer;
@synthesize ct;

-(id) showTimeBarInLayer:(CCLayer*)layer{
    
    glayer=(GameLayer*)layer;
    CCSprite *background=[CCSprite spriteWithFile:@"timebar_background.png"];
    CGSize size = [[CCDirector sharedDirector] winSize];
    background.position=ccp( size.width /1.7 , size.height/1.08);
    [glayer addChild:background z:20 tag:20];
    
    CCSprite *timebar=[CCSprite spriteWithFile:@"timebar.png"];
    ct=[CCProgressTimer progressWithSprite:timebar];
    [ct setPosition:ccp( size.width /1.7 , size.height/1.08)];
    ct.barChangeRate=ccp(0.775,0);
    ct.midpoint=ccp(0,1);
    [ct setPercentage:40];
    [ct setType:kCCProgressTimerTypeBar];
    ct.percentage+=9;
    [glayer addChild:ct z:21 tag:21];
    return self;
}
-(void)updateTimeBar:(float)percentage{
    
    //temp
    ct.percentage-=1;
    if(ct.percentage==0)
        ct.percentage=50;
}
@end
