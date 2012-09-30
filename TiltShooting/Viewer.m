//
//  Viewer.m
//  TiltShooting
//
//  Created by yan zhuang on 12-9-18.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Viewer.h"


@implementation Viewer

//Debug Message
+(void)NSLogDebug:(BOOL)debug withMsg:(NSString*)message{
    if(debug){
        NSLog(message);
    }
    
}
+(void) showMenuBackground:(CCLayer*)layer{


}
+(void) showBulletHole:(CCLayer*)layer atLocation:(CGPoint)location{
    GameLayer *glayer=(GameLayer*)layer;
    //CCSpriteBatchNode *SheetBulletHolesBig = [CCSpriteBatchNode batchNodeWithFile:@"bulletholesbig.png" capacity:12];
    CCSprite *bulletHoleBig = [CCSprite spriteWithFile:@"bulletholesbig.png" rect:CGRectMake(0,0,40,40)];
    //[glayer.background addChild:SheetBulletHolesBig];
    [glayer.background addChild:bulletHoleBig z:1];
    bulletHoleBig.position=[Viewer viewToCanvas:glayer at:location];

}
//temp for test
+(CGPoint)viewToCanvas:(GameLayer*)layer at:(CGPoint)location{
#define CANVASW 1440
#define CANVASH 960
    CGSize size = [[CCDirector sharedDirector] winSize];
    CGPoint p=ccp(location.x+CANVASW/2-layer.background.position.x,location.y+CANVASH/2-layer.background.position.y);
    return p;
}
+(void) showTarget:(Target*)target inLayer:(CCLayer*)layer{
    GameLayer *glayer=(GameLayer*)layer;
    
    TargetSprite *tg=[CCSprite spriteWithFile:@"bricktargetgreen.png"];
    [glayer.background addChild:tg z:1];
    tg.position=ccp(target.x,target.y);
    NSLog(@"add target at x=%f y=%f",target.x,target.y);
    target.aux=tg;

}

+(void) showBomb:(Target*)target inLayer:(CCLayer*)layer{
    //show a red brick as bomb for test
    GameLayer *glayer=(GameLayer*)layer;
    
    TargetSprite *tg=[CCSprite spriteWithFile:@"bricktargetred.png"];
    [glayer.background addChild:tg z:1];
    tg.position=ccp(target.x,target.y);
    NSLog(@"add Bomb at x=%f y=%f",target.x,target.y);
    target.aux=tg;

}

+(void) showAim:(Target*)target inLayer:(CCLayer*)layer{
    //show aim for test
    GameLayer *glayer=(GameLayer*)layer;
    CCSprite *aimCross=[CCSprite spriteWithFile:@"aimcross.png"];
    aimCross.position =  ccp(target.x,target.y);
    [glayer addChild:aimCross z:1 tag:1];
    NSLog(@"add AimCross at x=%f y=%f",target.x,target.y);
    target.aux=aimCross;

}
@end
