//
//  MenuLayer.m
//  TiltShooting
//
//  Created by yan zhuang on 12-9-17.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "MenuLayer.h"
#import "Model.h"
@interface MenuLayer()
@property (weak) CCLabelTTF *label;
@end

@implementation MenuLayer


-(id)init{

    if( (self=[super init] )) {
        NSLog(@"init MenuLayer");
        CGSize size = [[CCDirector sharedDirector] winSize];
        // create and initialize a Label
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Menu: Touch to play" fontName:@"Marker Felt" fontSize:48];
        // position the label on the center of the screen
        label.position =  ccp( size.width /2 , size.height/2 );
        self.label = label;
        // add the label as a child to this Layer
        [self addChild: label];    
        // register to model event listener
        id<ModelInterface>  model = [[Model class] instance];
        [model addToCoreEventListenerList:self];
    }
    return self;
}
// temp
-(void) onEnter
{
	[super onEnter];
    
	NSLog(@"Enter MenuLayer");
    
    //[Viewer showMenuBackground:self];
    
    // Enable touch
    [self setIsTouchEnabled:YES];
    
	// In one second transition to the new scene
	//[self scheduleOnce:@selector(makeTransition:) delay:1];
}

//tell director transfer to mainScene
-(void) makeTransition:(ccTime)dt
{
    CCScene *scene=[[MainScene node] initWithLevel:1];
     //[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:scene withColor:ccWHITE]];
     CCTransitionSlideInL *transitionScene = [CCTransitionSlideInL transitionWithDuration:1.5 scene:scene];
     //[[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
     
    [[CCDirector sharedDirector] runWithScene:transitionScene];
    
    
}
//start new game at certain level//(int)stage
-(void) startNewGame:(int)level{
    
}
// Load Game //maybe multiple records
-(void) loadGame:(int)recoredNumber{
    
    
    
}
// adjust volumn, etc
-(void) setOptions{
    //show optionScene
}
//help

-(void) showHelp{
    
    //show helpScene
    
}

// register to get touches input
-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"Menu Touch Began");
    NSLog(@"for model test only");
    id<ModelInterface> model = [[Model class] instance];
    if (model.status == RUNNING) {
        [model pause];
    } else if (model.status == STOPPED) {
        [model start];
    } else if (model.status == PAUSING) {
        [model resume];
    }
    return YES;
}
-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    //check which button
    //[self scheduleOnce:@selector(makeTransition:) delay:1];
    //CCScene *scene=[[MainScene node] initWithLevel:1];
    //[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:scene withColor:ccWHITE]];
    
}

- (BUBBLE_RULE) canvasMovetoX:(float)x Y:(float)y {
    [self.label setPosition:ccp(x, y)];
    return BUBBLE_CONTINUE;
}

- (BUBBLE_RULE) gameInitFinished {
    NSLog(@"Game init. finished");
    return BUBBLE_CONTINUE;
}
@end
