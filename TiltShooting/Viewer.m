//
//  Viewer.m
//  TiltShooting
//
//  Created by yan zhuang on 12-9-18.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Viewer.h"
#import "Header.h"

@implementation Viewer

//Debug Message
+(void)NSLogDebug:(BOOL)debug withMsg:(NSString*)message{
    if(debug){
        NSLog(message);
    }
    
}
+(void) showMenuBackground:(CCLayer*)layer{


}
//show bullet hole at point on view window
+(void) showBulletHole:(CCLayer*)layer atPoint:(CGPoint)location{
    int i= arc4random() % 12;
    CCSprite *bulletHoleBig = [CCSprite spriteWithFile:@"bulletholesbig.png" rect:CGRectMake(30*i,0,30,30)];
    //[glayer.background addChild:SheetBulletHolesBig];
    [layer addChild:bulletHoleBig z:2];
    bulletHoleBig.position = location;

}
//show bullet hole at location of aimcross
+(void) showBulletHole:(CCLayer*)layer atLocation:(CGPoint)location{
    GameLayer *glayer=(GameLayer*)layer;
    //CCSpriteBatchNode *SheetBulletHolesBig = [CCSpriteBatchNode batchNodeWithFile:@"bulletholesbig.png" capacity:12];
    //random hole in 12 types
    int i= arc4random() % 12;
    CCSprite *bulletHoleBig = [CCSprite spriteWithFile:@"bulletholesbig.png" rect:CGRectMake(30*i,0,30,30)];
    //[glayer.background addChild:SheetBulletHolesBig];
    [glayer.background addChild:bulletHoleBig z:1];
    bulletHoleBig.position=[Viewer viewToCanvas:glayer at:location];
    id<ModelInterface> m = [[Model class] instance];
    bulletHoleBig.position = ccp (m.aim.x, m.aim.y);

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
    TargetSprite *tg=[CCSprite spriteWithFile:@"aimcross.png"];
    [glayer.background addChild:tg z:10];
    tg.position=ccp(target.x,target.y);
    NSLog(@"add AimCross at x=%f y=%f",target.x,target.y);
    target.aux=tg;
}
@end
