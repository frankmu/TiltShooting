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

@synthesize background;

-(id)init{

    if( (self=[super init] )) {
        NSLog(@"init MenuLayer");
        CGSize size = [[CCDirector sharedDirector] winSize];
        // create and initialize a Label
        //CCLabelTTF *label = [CCLabelTTF labelWithString:@"Menu: Touch to play" fontName:@"Marker Felt" fontSize:48];
        // position the label on the center of the screen
        //label.position =  ccp( size.width /2 , size.height/2 );
        
        // add the label as a child to this Layer
        //[self addChild: label z:0 tag:1];
        
		// Load background 480*320 this time
		background = [CCSprite spriteWithFile:@"menu_background.png"];
		[self addChild:background z:0 tag:9];
        background.position=ccp( size.width /2 , size.height/2 );
        
        //add 4 buttons
        CCMenuItemImage *newGame = [CCMenuItemImage itemFromNormalImage:@"menu_button1.png" selectedImage:@"menu_button1_sel.png" disabledImage:nil target:self selector:@selector(stratNewGame:)];
        newGame.position=ccp(100,75);
        
        CCMenuItemImage *loadGame = [CCMenuItemImage itemFromNormalImage:@"menu_button2.png" selectedImage:@"menu_button2_sel.png" disabledImage:nil target:self selector:@selector(stratNewGame:)];
        loadGame.position=ccp(100,20);
        
        CCMenuItemImage *settings = [CCMenuItemImage itemFromNormalImage:@"menu_button3.png" selectedImage:@"menu_button3_sel.png" disabledImage:nil target:self selector:@selector(setOptions:)];
        settings.position=ccp(100,-35);
        CCMenuItemImage *help = [CCMenuItemImage itemFromNormalImage:@"menu_button4.png" selectedImage:@"menu_button4_sel.png" disabledImage:nil target:self selector:@selector(showHelp:)];
        help.position=ccp(100,-90);
        
        [CCMenuItemFont setFontSize:25];
        
        //disable 2 buttons
        [loadGame setIsEnabled:NO];
        [settings setIsEnabled:NO];
        
        //add the buttons to the layer
        CCMenu *mn = [CCMenu menuWithItems:newGame, loadGame, settings, help, nil];
        //[mn alignItemsVertically];
        [self addChild:mn z:1 tag:2];
        
        /*// register to model event listener
        id<ModelInterface>  model = [[Model class] instance];
        [model addToCoreEventListenerList:self];
         */
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
-(void) stratNewGame:(id)sender{
    CCScene *scene=[[MainScene node] initWithLevel:1];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:scene withColor:ccWHITE]];
}
-(void) startNewGame:(id)sender withLevel:(int)level{
    
}
// Load Game //maybe multiple records
-(void) loadGame:(int)recoredNumber{
    
    
    
}
// adjust volumn, etc
-(void) setOptions:(id)sender{
    //show optionScene
}
//help

-(void) showHelp:(id)sender{
    
    //show helpScene
    CCScene *scene=[HelperScene node];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:scene withColor:ccWHITE]];
}

// register to get touches input
-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"Menu Touch Began");
    /*NSLog(@"for model test only");
    id<ModelInterface> model = [[Model class] instance];
    if (model.status == RUNNING) {
        [model stop];
    } else {
        [model start];
    }*/
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

/*- (void) newGame:(id) sender {
    //change to new game scene
    //[[CCDirector sharedDirector] replaceScene: [CCSlideInRTransition transitionWithDuration:1.2f scene:sc]];
    CCScene *scene=[[MainScene node] initWithLevel:1];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:scene withColor:ccWHITE]];
}
 */
/*- (void) help:(id) sender {
    //change to help scene
    //[[CCDirector sharedDirector] replaceScene: [CCSlideInRTransition transitionWithDuration:1.2f scene:sc]];
    CCScene *scene=[HelperScene node];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:scene withColor:ccWHITE]];
 }
 */
@end
