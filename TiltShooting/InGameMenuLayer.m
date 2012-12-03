//
//  InGameMenuLayer.m
//  TiltShooting
//
//  Created by yan zhuang on 12-10-3.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "InGameMenuLayer.h"
#import "SimpleAudioEngine.h"
#import "GameLayer.h"
#import "CCBReader.h"
#define BULLETNUM 2
@implementation InGameMenuLayer

-(id)initWithGameLayer:(CCLayer*)layer{
    //stop bg music
    [[SimpleAudioEngine sharedEngine]   stopBackgroundMusic];
    self.glayer=layer;
    //menu button
    CGSize size = [[CCDirector sharedDirector] winSize];
    // Load background
    self.background = [CCSprite spriteWithFile:@"pausebg.png"];
    [self addChild:self.background z:0];
    self.background.position = ccp(size.width * 0.5, size.height * 0.5);
        
     
    //add Resume button
    CCMenuItemImage *resume = [CCMenuItemImage itemFromNormalImage:@"resume.png" selectedImage:@"resume2.png" disabledImage:nil target:self selector:@selector(resumeGame:)];
    
    CCMenuItemImage *restart = [CCMenuItemImage itemFromNormalImage:@"restart.png" selectedImage:@"restart2.png" disabledImage:nil target:self selector:@selector(stratNewGame:)];
    restart.position= ccp(size.width * 0.5, size.height * 0.5);
    
     CCMenuItemImage *mainMenu = [CCMenuItemImage itemFromNormalImage:@"mainmenu.png" selectedImage:@"mainmenu2.png" disabledImage:nil target:self selector:@selector(returnToMenu:)];
    
    [CCMenuItemFont setFontSize:25];
    
    //disable for now
    //[restart setIsEnabled:NO];
    
    CCMenu *pauseMenu = [CCMenu menuWithItems: resume, restart, mainMenu, nil];
    [pauseMenu alignItemsVertically];
    pauseMenu.position = ccp(size.width * 0.5, size.height * 0.5);
    [self addChild:pauseMenu z:1];
    
    //[self setIsTouchEnabled:YES];
    return self;
}
//Resume

-(void) resumeGame:(id)sender{
    
    NSLog(@"Enter resumeGame");
    for (int i=0; i<BULLETNUM; i++) {
        [self showBulletHoleOnButton:sender];
    }
    //remove all buttons, etc
    [self removeAllChildrenWithCleanup:YES];
    
    //resume model
    id<ModelInterface>  model = [[Model class] instance];
    [model resume];
    [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
    //enable gamelayer touch
    [self.glayer setIsTouchEnabled:YES];
    //[self setIsTouchEnabled:NO];
    }

//Restart
-(void) stratNewGame:(id)sender{
    
    NSLog(@"Enter stratNewGame");
    
    for (int i=0; i<BULLETNUM; i++) {
        [self showBulletHoleOnButton:sender];
    }
    NSLog(@"restart a new game ");
    id<ModelInterface>  model = [[Model class] instance];
    [model resume];
 
    [model stop];
    NSLog(@"ingamemenulayer resume model before restart");
    //***** need fix here, model should support restart, reset when stop
    //[(GameLayer*)self.glayer restartGame];
    CCScene *scene;
    if(((GameLayer*)self.glayer).facebookEnable){
         scene=[CCBReader sceneWithNodeGraphFromFile:@"ModeMenu.ccbi"];
    }
    else{
        scene=[[MainScene node] initWithLevel:1];
    }
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:scene withColor:ccWHITE]];
}

//return to the main menu
-(void) returnToMenu:(id)sender{
    
    NSLog(@"Enter returnToMenu");
    
    for (int i=0; i<BULLETNUM; i++) {
        [self showBulletHoleOnButton:sender];
    }
    id<ModelInterface>  model = [[Model class] instance];
    [model resume];
    
    [model stop];
    //CCScene *sc = [MenuScene node];
    CCScene* mainScene = [CCBReader sceneWithNodeGraphFromFile:@"MainMenu.ccbi"];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:mainScene withColor:ccWHITE]];
}


//show bullet holes effect on a button
-(void) showBulletHoleOnButton:(CCMenuItemImage*)button{
    //randomly show a bullet hole
    
    float w = CCRANDOM_MINUS1_1() * button.contentSize.width/2;  //((float)arc4random()/RAND_MAX)-0.5)
    float h = CCRANDOM_MINUS1_1() * button.contentSize.height/2;
    //? seems menu treat center as (0,0)
    [Viewer showBulletHole:self atPoint:ccp(button.position.x+w+240,button.position.y+h+160)];
    // NSLog(@"show bullethole at x=%f y=%f",button.position.x+w+240,button.position.y+h+160);
    [[SimpleAudioEngine sharedEngine] playEffect:@"Rifle_GunShot.mp3"];
}

@end
