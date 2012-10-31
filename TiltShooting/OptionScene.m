//
//  OptionScene.m
//  TiltShooting
//
//  Created by yan zhuang on 12-9-18.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "OptionScene.h"


@implementation OptionScene
@synthesize optionLayer;
@synthesize optionScene;

-(id) init{
    if( (self=[super init] ))
	{
        optionScene=self;//[CCScene node];
        
        optionLayer=[OptionLayer node];
        
        [optionScene addChild:optionLayer z:0 tag:0];
    }
    return self;
}

@end
