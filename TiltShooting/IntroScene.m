//
//  IntroScene.m
//  TiltShooting
//
//  Created by yan zhuang on 12-9-17.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "IntroScene.h"


@implementation IntroScene

@synthesize introLayer = _introLayer;
@synthesize introScene = _introScene;
+(id) ShowScene{
    
    return nil;
    //return [self introScene];
}

-(id) init{
    
    self.introScene = [CCScene node];
    
    self.introLayer = [IntroLayer node];
    
    [self.introScene addChild:self.introLayer z:0 tag:0];
    return self;
}

@end
