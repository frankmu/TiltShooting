//
//  MenuScene.m
//  TiltShooting
//
//  Created by yan zhuang on 12-9-19.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "MenuScene.h"
#import "MenuLayer.h"

@implementation MenuScene

@synthesize menuLayer;
@synthesize menuScene;


-(id) init{
    if( (self=[super init] ))
	{
        menuScene=self;//[CCScene node];
    
        menuLayer=[MenuLayer node];
    
        [menuScene addChild:menuLayer z:0 tag:0];
    }
    return self;
}

@end
