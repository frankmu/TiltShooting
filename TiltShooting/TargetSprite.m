//
//  TargetSprite.m
//  TiltShooting
//
//  Created by yan zhuang on 12-9-15.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "TargetSprite.h"
#import "GameLayer.h"

@implementation TargetSprite




+ (id) TargetWithinLayerBackground:(CCLayer *) layer imageFile:(NSString*) imgFile{
    GameLayer *ly = (GameLayer *)layer;
    TargetSprite *target = [CCSprite spriteWithFile:@"bricktargetgreen.png"];
    //as child of background
    [ly.background addChild:target];   //release??
    
    
    //target position ?????
    target.position=ccp(200,160);
    
    
	/*
	CCSpriteSheet *animationsSheet = [CCSpriteSheet spriteSheetWithFile:imgFile capacity:3];
	[ly.gameWorld addChild:animationsSheet z:99 tag:1];
	
	TargetSprite *sprite = [TankSprite spriteWithTexture:animationsSheet.texture rect:CGRectMake(0, 0, 40, 40)];
	[animationsSheet addChild:sprite z:0 tag:1];
    
	[sprite SetLayer:layer];
	[sprite TankInit];
    */
    
	return target;



}
@end
