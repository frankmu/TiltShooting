//
//  GameOverScene.m
//  TiltShooting
//
//  Created by yan zhuang on 12-9-17.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameOverScene.h"
#import "SimpleAudioEngine.h"
#import "CCBReader.h"
@implementation GameOverScene
@synthesize background;
@synthesize win;
@synthesize score;
-(id)start{
    
    //if( (self=[super init] )) {
    
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    
    CCLayer *scoreLayer=[CCLayer node];
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    
    background = [CCSprite spriteWithFile:@"help_background.png"];
    [scoreLayer addChild:background z:0 tag:0];
    background.position=ccp( size.width /2 , size.height/2 );
    
    CCSprite *blurLayer = [CCSprite spriteWithFile:@"gameover_blur.png"];
    [scoreLayer addChild:blurLayer z:1 tag:1];
    blurLayer.position=ccp( size.width /2 , size.height/1.8 );
    blurLayer.opacity=150;
    blurLayer.scale=1.1;
    
    CCMenuItemImage *retry = [CCMenuItemImage itemFromNormalImage:@"gameover_retry.png" selectedImage:@"gameover_retry_sel.png" disabledImage:nil target:self selector:@selector(retry:)];
    retry.position=ccp(-150,-120);
    //self.retry=retry;
    CCMenuItemImage *nextLevel= [CCMenuItemImage itemFromNormalImage:@"gameover_nextlevel.png" selectedImage:@"gameover_nextlevel_sel.png" disabledImage:nil target:self selector:@selector(nextlevel:)];
    nextLevel.position=ccp(0,-120);
    //self.nextlevel=nextLevel;
    CCMenuItemImage *mainMenu = [CCMenuItemImage itemFromNormalImage:@"gameover_mainmenu.png" selectedImage:@"gameover_mainmenu_sel.png" disabledImage:nil target:self selector:@selector(mainmenu:)];
    mainMenu.position=ccp(150,-120);
    //self.mainMenu=mainMenu;
    
    [nextLevel setIsEnabled:NO];
    CCMenu *mn = [CCMenu menuWithItems:retry, nextLevel, mainMenu, nil];
    [scoreLayer addChild:mn z:2 tag:2];
    
    //create and initialize a Label
    NSString *state = @"";
    if (win) {
        state=@"You Win!!";
    }else{
        state=@"You Lose.";
    }
    CCLabelTTF *result = [CCLabelTTF labelWithString:state fontName:@"Zapfino" fontSize:48];
    //position the label on the center of the screen
    result.position =  ccp( size.width /3 , size.height/1.25 );
    [scoreLayer addChild:result z:3 tag:3];
    
    //create and initialize a Label
    CCLabelTTF *scoreFont= [CCLabelTTF labelWithString:@"Score:" fontName:@"Marker Felt" fontSize:48];
    //position the label on the center of the screen
    scoreFont.position =  ccp( size.width /4 , size.height/1.6 );
    [scoreLayer addChild:scoreFont z:4 tag:4];
    
    CCLabelTTF *scoreNumber=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",(int)self.score] fontName:@"Marker Felt" fontSize:48];
    scoreNumber.anchorPoint=ccp(0,0);
    scoreNumber.position =  ccp( size.width /2.8 , size.height/1.9 );
    [scoreLayer addChild:scoreNumber z:5 tag:5];
    //create and initialize a Label
    CCLabelTTF *time = [CCLabelTTF labelWithString:@"Time:" fontName:@"Marker Felt" fontSize:48];
    //position the label on the center of the screen
    time.position =  ccp( size.width /4 , size.height/2.4 );
    [scoreLayer addChild:time z:6 tag:6];
    
    [self addChild: scoreLayer z:0 tag:1];
    
    //}
    return self;
}

-(void) mainmenu: (id) sender
{
	//CCScene *sc = [MenuScene node];
    CCScene* mainScene = [CCBReader sceneWithNodeGraphFromFile:@"MainMenu.ccbi"];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:mainScene withColor:ccWHITE]];
}
-(void) retry:(id)sender
{
    
    CCScene *scene=[[MainScene node] initWithLevel:1];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:2 scene:scene withColor:ccWHITE]];
}

@end
