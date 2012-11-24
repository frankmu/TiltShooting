//
//  Viewer.m
//  TiltShooting
//
//  Created by yan zhuang on 12-9-18.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Viewer.h"
#import "Header.h"
#import "SimpleAudioEngine.h"
#import "Weapon.h"
@implementation Viewer
@synthesize spriteSheet;
@synthesize explodeAnim;
@synthesize weaponList;
@synthesize weaponSpriteList;
@synthesize currentWeaponIndex;
@synthesize nextWeaponIndex;
@synthesize glayer;
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
    [layer addChild:bulletHoleBig z:15];
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
    [glayer.background addChild:bulletHoleBig z:5];
    //bulletHoleBig.position=[Viewer viewToCanvas:glayer at:location];
    id<ModelInterface> m = [[Model class] instance];
    bulletHoleBig.position = ccp (m.aim.x, m.aim.y);
    //remove after 2s
    CCSequence *sequence=[CCSequence actions:
                          [CCDelayTime actionWithDuration:0.5],
                          [CCCallFuncO actionWithTarget:glayer selector:@selector(removeChildFromParent:) object:bulletHoleBig],
                          nil];
    [bulletHoleBig runAction:sequence];
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
//show a big sign on view and disapear
+(void) showBigSign:(NSString*)sign inLayer:(CCLayer*)layer withDuration:(ccTime)d{
    CCLabelTTF *msg=[CCLabelTTF labelWithString:sign fontName:@"Marker Felt" fontSize:48];
    [layer addChild:msg];
    CGSize size = [[CCDirector sharedDirector] winSize];
    msg.position =  ccp( size.width /2 , size.height/2 );
    [msg runAction:[CCSequence actions:[CCScaleTo actionWithDuration:d/2.0 scale:1.3],
                    [CCScaleTo actionWithDuration:d/2.0 scale:1],
                    [CCCallFuncO actionWithTarget:layer selector:@selector(removeChildFromParent:) object:msg],nil]];
}
//remove
+(void) removeTarget:(Target*)target inLayer:(CCLayer*)layer{
    //[Viewer showExplodeInBackground:((GameLayer*)layer).background at:ccp(target.x,target.y)];
    [target.aux removeFromParentAndCleanup:YES];
}
+(void) removeBomb:(Target*)target inLayer:(CCLayer*)layer{
    [target.aux removeFromParentAndCleanup:YES];
    
}
+(void) removeAim:(Target*)target inLayer:(CCLayer*)layer{
    [target.aux removeFromParentAndCleanup:YES];
    
}
-(void) showExplodeInLayer:(CCLayer*)layer at:(CGPoint)location {
    
    CCAction *explodeAction =[CCAnimate actionWithAnimation:explodeAnim];
    //run
    CCSprite *explode= [CCSprite spriteWithSpriteFrameName:@"explode1.png"];
    explode.position = location;
    [spriteSheet addChild:explode z:6];
    NSLog(@"start to run animation on target");
    [[SimpleAudioEngine sharedEngine] playEffect:@"explode.mp3"];
    [explode runAction:[CCSequence actions:explodeAction,
                        [CCCallFuncO actionWithTarget:layer selector:@selector(removeChildFromParent:) object:explode],nil]];
    
}
-(void)changeWeaponInLayer{
    
    CCAction *movedown=[CCMoveTo actionWithDuration:1 position:ccp(240,-30)];
    CCAction *moveup=[CCMoveTo actionWithDuration:1 position:ccp(240,30)];
    CCAction *scaleto=[CCScaleTo actionWithDuration:1 scale:0.3];
    CCAction *scaleback=[CCScaleTo actionWithDuration:0 scale:1];

    [[weaponSpriteList objectAtIndex:currentWeaponIndex] runAction:movedown];
    [[weaponSpriteList objectAtIndex:currentWeaponIndex] runAction:[CCSequence actions:scaleto,scaleback,nil]];
    [[weaponSpriteList objectAtIndex:nextWeaponIndex] runAction:moveup];
    currentWeaponIndex=nextWeaponIndex;
    
}
-(void)showPreviousWeapon{
      //check weapon number
    if([weaponSpriteList count]==0){
        [Viewer showBigSign:@"Error:No Weapon" inLayer:glayer withDuration:1];
    }

    else if([weaponSpriteList count]==1){
        [Viewer showBigSign:@"No Extra Weapon" inLayer:glayer withDuration:1];
    }
    else if(currentWeaponIndex==0){
        nextWeaponIndex=[weaponSpriteList count]-1;
        [self changeWeaponInLayer];
    }
    else{
        nextWeaponIndex=currentWeaponIndex-1;
        [self changeWeaponInLayer];

    }
}
-(void)showNextWeapon{
    //check weapon number
    if([weaponSpriteList count]==0){
        [Viewer showBigSign:@"Error:No Weapon" inLayer:glayer withDuration:1];
    }
    
    else if([weaponSpriteList count]==1){
        [Viewer showBigSign:@"No Extra Weapon" inLayer:glayer withDuration:1];
    }
    else if(currentWeaponIndex==([weaponSpriteList count]-1)){
        nextWeaponIndex=0;
        [self changeWeaponInLayer];
    }
    else{
        nextWeaponIndex=currentWeaponIndex+1;
        [self changeWeaponInLayer];
        
    }
}

-(id)initWithLayer:(CCLayer*)layer{
    if (self = [super init]) {
        NSLog(@"init viewer for animation cache");
        //cache frames
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:
         @"aniexplode.plist"];
        //sprite batch node , child of bg
        spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"aniexplode.png"];
        [((GameLayer*)layer).background addChild:self.spriteSheet z:6];
        //store layer
        glayer=(GameLayer*)layer;
        //gather list of frames, explode1.phg -> explode13.png
        NSMutableArray *explodeAnimFrames = [NSMutableArray array];
        for(int i = 1; i <= 13; ++i) {
            [explodeAnimFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"explode%d.png", i]]];
        }
        //animation
        explodeAnim = [CCAnimation animationWithFrames:explodeAnimFrames delay:0.1f];
        
        /*************init weapon*************/
        //get weapon info from model
        //now hardcode weapon status , support 3 types
        NSLog(@"init weapons");
        //#################
        //init weapon based on model weapon list
        //################
        NSArray *weapons=[NSArray arrayWithObjects:[NSNumber numberWithBool:YES],[NSNumber numberWithBool:YES],[NSNumber numberWithBool:NO],nil];
        //init weaponList
        weaponList=[[NSMutableArray alloc] initWithCapacity: 3];
        for (int j=0; j<[weapons count]; j++) {
            if([[weapons objectAtIndex:j] boolValue]){
                NSLog(@"init weapon type %d",j+1);
                [weaponList addObject:[[Weapon node]initWithType:j+1]];
            
            }        
        }
        //default init weapon type
        currentWeaponIndex=0;
        nextWeaponIndex=0;
        NSLog(@"weaponlist count= %d",[weaponList count]);
        //draw all weapon,show current weapon at bottom, others outside the screen
        weaponSpriteList=[[NSMutableArray alloc] initWithCapacity: 3];
        for (int i=0; i<[weaponList count]; i++) {
            CCSprite *weapon=[CCSprite spriteWithFile:((Weapon*)[weaponList objectAtIndex:i]).image];
            NSLog(@"add weapon into gamelayer");
            [glayer addChild:weapon];
            //store in list for switching positions
            [weaponSpriteList addObject:weapon];
            if(i==currentWeaponIndex){
                weapon.position=ccp(240,30);
            }
            else{
                weapon.position=ccp(240,-30);
            }
        }

    }
    return self;
    
    
}
@end
