//
//  MainMenu.m
//  TiltShooting
//
//  Created by Frank Mu on 11/4/12.
//
//
#import "MainMenu.h"
#import "CCBReader.h"
#import "GameLayer.h"
#import "SimpleAudioEngine.h"
#define BULLETNUM 2
@implementation MainMenu
-(id)init{
    
    if( (self=[super init] )) {
        NSLog(@"init MenuLayer");
        //preload menubgmusic
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"Rifle_Gunshot.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"menumusic_10s.mp3"];
    }
    return self;
}
-(void) onEnter
{
	[super onEnter];
    
	NSLog(@"Enter MenuLayer");
    
    //[Viewer showMenuBackground:self];

    //play bg music
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"menumusic_10s.mp3" loop:YES];
	// In one second transition to the new scene
	//[self scheduleOnce:@selector(makeTransition:) delay:1];
}
-(void) startNewGame:(id)sender{
    
    for (int i=0; i<BULLETNUM; i++) {
       [self showBulletHoleOnButton:sender];
   }
    
    //CCScene *scene=[[MainScene node] initWithLevel:1];
    CCScene* modeScene = [CCBReader sceneWithNodeGraphFromFile:@"ModeMenu.ccbi"];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:3 scene:modeScene withColor:ccWHITE]];
}
-(void) startNewGame:(id)sender withLevel:(int)level{
    
}
// Load Game //maybe multiple records

// adjust volumn, etc
-(void) setOptions:(id)sender{
    for (int i=0; i<BULLETNUM; i++) {
       [self showBulletHoleOnButton:sender];
    }
    //show optionScene
    CCScene *scene=[OptionScene node];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:3 scene:scene withColor:ccWHITE]];
}
//help

-(void) showHelp:(id)sender{
    for (int i=0; i<BULLETNUM; i++) {
        [self showBulletHoleOnButton:sender];
    }
    //show helpScene
    CCScene *scene=[HelperScene node];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:3 scene:scene withColor:ccWHITE]];
}
//show bullet holes effect on a button
-(void) showBulletHoleOnButton:(CCMenuItemImage*)button{
    //randomly show a bullet hole
    
    float w = CCRANDOM_MINUS1_1() * button.contentSize.width/2;  //((float)arc4random()/RAND_MAX)-0.5)
    float h = CCRANDOM_MINUS1_1() * button.contentSize.height/2;
    //? seems menu treat center as (0,0)
    [Viewer showBulletHole:self atPoint:ccp(button.position.x+w+240,button.position.y+h+160)];
    //NSLog(@"show bullet at menulayer x=%f, y=%f",button.position.x+w+240,button.position.y+h+160);
    // NSLog(@"show bullethole at x=%f y=%f",button.position.x+w+240,button.position.y+h+160);
    [[SimpleAudioEngine sharedEngine] playEffect:@"Rifle_GunShot.mp3"];
}
@end
