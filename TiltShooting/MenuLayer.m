//
//  MenuLayer.m
//  TiltShooting
//
//  Created by yan zhuang on 12-9-17.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "MenuLayer.h"


@implementation MenuLayer


-(id)init{

    if( (self=[super init] )) {

    

    }
    return self;
}
// temp
-(void) onEnter
{
	[super onEnter];
    
	CGSize size = [[CCDirector sharedDirector] winSize];
    // create and initialize a Label
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Menu" fontName:@"Marker Felt" fontSize:64];
    // position the label on the center of the screen
    label.position =  ccp( size.width /2 , size.height/2 );
    
    // add the label as a child to this Layer
    [self addChild: label];
	
	// In one second transition to the new scene
	[self scheduleOnce:@selector(makeTransition:) delay:1];
}

-(void) makeTransition:(ccTime)dt
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainScene ShowScene] withColor:ccWHITE]];
}

@end
