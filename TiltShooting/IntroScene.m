//
//  IntroScene.m
//  TiltShooting
//
//  Created by yan zhuang on 12-9-17.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "IntroScene.h"


@implementation IntroScene

//@synthesize introLayer = _introLayer;
@synthesize introScene = _introScene;
+(id) ShowScene{
    
    return nil;
    //return [self introScene];
}

-(id) init{
    
    // always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] ))
	{
        NSLog(@"Initialize the IntroScene with a child IntroLayer");
        
        self.introScene = self;//[CCScene node];
        
        //self.introLayer = [IntroLayer node];
        IntroLayer *introLayer=[IntroLayer node];
        [self.introScene addChild:introLayer z:0 tag:1];
    }

    return self;
}

@end
