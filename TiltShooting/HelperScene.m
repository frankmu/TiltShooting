//
//  HelperScene.m
//  TiltShooting
//
//  Created by yan zhuang on 12-9-18.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "HelperScene.h"
#import "CCBReader.h"

@implementation HelperScene
@synthesize background;
-(id)init{
    
    if( (self=[super init] )) {
        CCLayer *helpLayer=[CCLayer node];
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        //create and initialize a Label
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Option" fontName:@"Marker Felt" fontSize:48];
        //position the label on the center of the screen
        label.position =  ccp( size.width /2 , size.height/2 );
        
        background = [CCSprite spriteWithFile:@"help_background.png"];
		[helpLayer addChild:background z:0 tag:9];
        background.position=ccp( size.width /2 , size.height/2 );
        
        [CCMenuItemFont setFontSize:20];
		CCMenuItem *backToMenu = [CCMenuItemFont itemFromString:@"Back" target:self selector:@selector(onBack:)];
		CCMenu *mn = [CCMenu menuWithItems:backToMenu, nil];
		[mn alignItemsVertically];
		mn.position = ccp (480 - 50, 30);
        
		[helpLayer addChild:mn z:1 tag:2];        // add the label as a child to this Layer
        [helpLayer addChild: label z:2 tag:3];
        [self addChild: helpLayer z:0 tag:1];
        
    }
    return self;
}
-(void) onBack: (id) sender
{
	//CCScene *sc = [MenuScene node];
    CCScene* mainScene = [CCBReader sceneWithNodeGraphFromFile:@"MainMenu.ccbi"];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:mainScene withColor:ccWHITE]];}
@end
