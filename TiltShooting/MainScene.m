//
//  MainScence.m
//  TiltShooting
//
//  Created by yan zhuang on 12-9-15.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "MainScene.h"
#import "GameLayer.h"

@implementation MainScene
@synthesize myScene = _myScene;

// Great the mainScene with gameLayer as its child
+(id) ShowScene
{
	// 'scene' is an autorelease object.
	    
	// return the scene
    return nil;
    // class method can't return instance pointer
	//return [self myScene];
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] ))
	{
        
	    self.myScene = [MainScene node];
		GameLayer *glayer = [GameLayer node];
		//ControlLayer *clayer = [ControlLayer node];

		
		// add layer as a child to scene
		[self addChild: glayer z:0 tag:1];

        
       	}
	return self;
}

/* disabled for ARC
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
	
	// don't forget to call "super dealloc"
	//[super dealloc];
}
*/

@end

