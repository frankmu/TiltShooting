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
#import "TimePlusNode.h"
#import "TargetNode.h"
#import "DesertEagle.h"
#import "M4A1.h"
#import "CBTarget.h"
#import "CCBReader.h"
#import "CBAimCross.h"
@implementation Viewer
@synthesize spriteSheet;
@synthesize explodeAnim;
@synthesize weaponList;
@synthesize weaponSpriteList;
@synthesize currentWeaponIndex;
@synthesize nextWeaponIndex;
@synthesize glayer;

#define TARGET_SIZE 40.0
#define BOMB_SIZE 32.0
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
    [glayer.background addChild:bulletHoleBig z:0];
    //###########
    //temp scale down
    //##########
   
    //bulletHoleBig.position=[Viewer viewToCanvas:glayer at:location];
    id<ModelInterface> m = [[Model class] instance];
    bulletHoleBig.position = ccp (m.aim.x, m.aim.y);
    bulletHoleBig.scaleX=0.7;
    bulletHoleBig.scaleY=0.7;
    //remove after 0.5s
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
/*******------- Show -----------*******/
+(void) showTarget:(Target*)target inLayer:(CCLayer*)layer{
    GameLayer *glayer=(GameLayer*)layer;
    
    /*TargetSprite *tg=[CCSprite spriteWithFile:@"bricktargetgreen.png"];
    [glayer.background addChild:tg z:1];
    tg.position=ccp(target.x,target.y);
    NSLog(@"add target at x=%f y=%f",target.x,target.y);
    target.aux=tg;*/
    
    //#################
    //change scale
    //################
    CCNode* tg;
    
    if(glayer.facebookEnable){
        int i= arc4random() % glayer.FBInfo.count;
        NSString *fileName = [NSString stringWithFormat:@"Test%d.png", glayer.targetNumber];
        //tg=(CCSprite* )[CCSprite spriteWithCGImage:([UIImage imageWithCGImage:((UIImage*)[glayer.FBInfo objectAtIndex:i]).CGImage]).CGImage key:fileName];
        tg=(CCSprite* )[CCSprite spriteWithCGImage:((UIImage*)[glayer.FBInfo objectAtIndex:i]).CGImage key:fileName];
    }
    else{
        tg=(CBTarget *)[CCBReader nodeGraphFromFile:@"TargetAnimation.ccbi"];
    }
    glayer.targetNumber++;
    [glayer.background addChild:tg z:1];
    tg.position=ccp(target.x,target.y);
    tg.scaleX=target.width/TARGET_SIZE;
    tg.scaleY=target.height/TARGET_SIZE;
    NSLog(@"add target at x=%f y=%f",target.x,target.y);
    target.aux=tg;
}

+(void) showBomb:(Target*)target inLayer:(CCLayer*)layer{
    //show a red brick as bomb for test
    //#################
    //use ccb bomb
    //################
    GameLayer *glayer=(GameLayer*)layer;
    
    CCNode* tg=[CCBReader nodeGraphFromFile:@"Bomb.ccbi"];
    [glayer.background addChild:tg z:1];
    tg.position=ccp(target.x,target.y);
    tg.scaleX=target.width/BOMB_SIZE;
    tg.scaleY=target.height/BOMB_SIZE;
    NSLog(@"add Bomb at x=%f y=%f",target.x,target.y);
    target.aux=tg;
    
}
+(void) showTimePlus:(Target*)target inLayer:(CCLayer*)layer{
    GameLayer *glayer=(GameLayer*)layer;
    TargetNode* tg=[[TimePlusNode alloc] initWithTarget:target];
    //TargetSprite *tg=[CCSprite spriteWithFile:@"bricktargetred.png"];
    [glayer.background addChild:tg z:1];
    //tg.position=ccp(target.x,target.y);
    NSLog(@"add Bomb at x=%f y=%f",target.x,target.y);
    target.aux=tg;



}
+(void) showAim:(Target*)target inLayer:(CCLayer*)layer{
    //show aim for test
    GameLayer *glayer=(GameLayer*)layer;
    CCNode* tg=glayer.currentWeapon.aim;
    //TargetSprite *tg=[CCSprite spriteWithFile:@"aimcross.png"];
    //CCNode* tg=glayer.currentWeapon.aim;
    //[glayer.background addChild:tg z:10];
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
/*******------- remove -----------*******/
+(void) removeTarget:(Target*)target inLayer:(CCLayer*)layer{
    //[Viewer showExplodeInBackground:((GameLayer*)layer).background at:ccp(target.x,target.y)];
    //[target.aux removeFromParentAndCleanup:YES];
    GameLayer *glayer=(GameLayer*)layer;
    if(!glayer.facebookEnable){
        CCNode* tea = [CCBReader nodeGraphFromFile:@"TargetExplosionAnimation.ccbi"];
        [glayer.background addChild:tea z:6];
        tea.position=ccp(target.x,target.y);
    }
   // [(CBTarget*)target.aux runTimeLine:@"TargetExplosion"];
    [target.aux removeFromParentAndCleanup:YES];
}
+(void) removeBomb:(Target*)target inLayer:(CCLayer*)layer{
    [target.aux removeFromParentAndCleanup:YES];
    
}
+(void) removeTimePlus:(Target*)target inLayer:(CCLayer*)layer{
    [target.aux removeFromParentAndCleanup:YES];
}
+(void) removeAim:(Target*)target inLayer:(CCLayer*)layer{
    //[target.aux removeFromParentAndCleanup:YES];
    GameLayer *glayer=(GameLayer*)layer;
    glayer.currentWeapon.aim.position=ccp(0,-30);
}
+(void) hitTarget:(Target*)target inLayer:(CCLayer*)layer{
    GameLayer *glayer=(GameLayer*)layer;
    CCNode* spark = [CCBReader nodeGraphFromFile:@"FireSpark.ccbi"];
    [glayer.background addChild:spark z:6];
    spark.position=ccp(target.x,target.y);
    
    //check health
    if(!glayer.facebookEnable){
        float health=target.hp/target.maxHp;
    
        if(health<0.6 && health>0.3){
            //random a light broke
            int i= arc4random() % 5+1;
            [(CBTarget*)target.aux runTimeLine:[NSString stringWithFormat:@"BrokeLight_%d",i]];
        }
        else if(health<=0.3){
            //random a light broke
            int i= arc4random() % 5+1;
            [(CBTarget*)target.aux runTimeLine:[NSString stringWithFormat:@"BrokeHard_%d",i]];
        }
    }

}
//special shoot
+(void) specialShootWithWeapon:(Weapon*)weapon inLayer:(CCLayer*)layer{

    id<ModelInterface> m = [[Model class] instance];
    [m specialShoot];
    //stop aim
    GameLayer *glayer=(GameLayer*)layer;
    [(CBAimCross*)glayer.currentWeapon.aim runTimeLine:@"NormalAim"];
    //special effect
    if (glayer.currentWeapon.type==2) {
        //show a big explosion, use normal explosion temp
        
    }

}
-(void) showExplodeInLayer:(CCLayer*)layer at:(CGPoint)location {
    
   /* CCAction *explodeAction =[CCAnimate actionWithAnimation:explodeAnim];
    //run
    CCSprite *explode= [CCSprite spriteWithSpriteFrameName:@"explode1.png"];
    explode.position = location;
    [spriteSheet addChild:explode z:6];
    NSLog(@"start to run animation on target");
    [[SimpleAudioEngine sharedEngine] playEffect:@"explode.mp3"];
    [explode runAction:[CCSequence actions:explodeAction,
                        [CCCallFuncO actionWithTarget:layer selector:@selector(removeChildFromParent:) object:explode],nil]];*/
    GameLayer *glayer=(GameLayer*)layer;
    CCNode* explosion = [CCBReader nodeGraphFromFile:@"Explosion.ccbi"];
    [glayer.background addChild:explosion z:6];
    explosion.position=location;
    [[SimpleAudioEngine sharedEngine] playEffect:@"explode.mp3"];
    
}
-(void)changeWeaponInLayer{
    
    CCAction *movedown=[CCMoveTo actionWithDuration:1 position:ccp(240,-30)];
    CCAction *moveup=[CCMoveTo actionWithDuration:1 position:ccp(240,30)];
    CCAction *scaleto=[CCScaleTo actionWithDuration:1 scale:0.3];
    CCAction *scaleback=[CCScaleTo actionWithDuration:0 scale:1];

    [((Weapon*)[weaponList objectAtIndex:currentWeaponIndex]).panel runAction:movedown];
    [((Weapon*)[weaponList objectAtIndex:currentWeaponIndex]).panel runAction:[CCSequence actions:scaleto,scaleback,nil]];
    [((Weapon*)[weaponList objectAtIndex:nextWeaponIndex]).panel runAction:moveup];
    currentWeaponIndex=nextWeaponIndex;
    //aim
    ((GameLayer*)self.glayer).currentWeapon=(Weapon*)[weaponList objectAtIndex:currentWeaponIndex];
    [self changeAimInLayer];
}
-(void)changeAimInLayer{
    //change the aim to current weapon's aim
    id<ModelInterface> m = [[Model class] instance];
    CCNode* preAim=[m aim].aux;
    preAim.position=ccp(0,-30);
    //in case in the special blink mode
    [(CBAimCross*)preAim runTimeLine:@"NormalAim"];
    CCNode* curAim=((GameLayer*)self.glayer).currentWeapon.aim;
    curAim.position=ccp([m aim].x,[m aim].y);
    [m aim].aux=curAim;
}
-(void)changeWeaponStatus:(WeaponBase*)weapon{
   Weapon* gun=weapon.aux;
    [gun changeClipAmmo:weapon.bulletCapacity];
    [gun changeCurrentAmmo:weapon.depotRemain];
    [gun changeCurrentClipAmmo:weapon.bulletRemain];
    
    
}
-(void)showPreviousWeapon{
      //check weapon number
     id<ModelInterface> m = [[Model class] instance];
    if([weaponList count]==0){
        [Viewer showBigSign:@"Error:No Weapon" inLayer:glayer withDuration:1];
    }

    else if([weaponList count]==1){
        [Viewer showBigSign:@"No Extra Weapon" inLayer:glayer withDuration:1];
    }
    else if(currentWeaponIndex==0){
        nextWeaponIndex=[weaponList count]-1;
        [m switchToPreviousWeapon];
        [self changeWeaponInLayer];
    }
    else{
        nextWeaponIndex=currentWeaponIndex-1;
        [m switchToPreviousWeapon];
        [self changeWeaponInLayer];

    }
}
-(void)showNextWeapon{
    //check weapon number
     id<ModelInterface> m = [[Model class] instance];
    if([weaponList count]==0){
        [Viewer showBigSign:@"Error:No Weapon" inLayer:glayer withDuration:1];
    }
    
    else if([weaponList count]==1){
        [Viewer showBigSign:@"No Extra Weapon" inLayer:glayer withDuration:1];
    }
    else if(currentWeaponIndex==([weaponList count]-1)){
        nextWeaponIndex=0;
        [m switchToNextWeapon];
        [self changeWeaponInLayer];
    }
    else{
        nextWeaponIndex=currentWeaponIndex+1;
         [m switchToNextWeapon];
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
        
    

    }
    return self;
    
    
}
-(void)initWeaponWithLayer:(CCLayer*)layer{
    /*************init weapon*************/
    //get weapon info from model
    //now hardcode weapon status , support 3 types
    NSLog(@"init weapons");
    
    //NSArray *weapons=[NSArray arrayWithObjects:[NSNumber numberWithBool:YES],[NSNumber numberWithBool:YES],[NSNumber numberWithBool:NO],nil];
    //init weaponList
    id<ModelInterface> m = [[Model class] instance];
    weaponList=[[NSMutableArray alloc] initWithCapacity: 3];
    for (int j=0; j<[[m weaponList] count]; j++) {
        /*if([[[m weaponList] objectAtIndex:j] boolValue]){
            NSLog(@"init weapon type %d",j+1);
            [weaponList addObject:[[Weapon node]initWithType:j+1]];
            
        }*/
        WeaponBase* modelGun=(WeaponBase*)[[m weaponList] objectAtIndex:j];
        if([[[m weaponList] objectAtIndex:j] isMemberOfClass:[DesertEagle class]]){
            Weapon* gun=[[Weapon node]initWithType:1];
            [weaponList addObject:gun];
            //init weapon status            
            [gun changeClipAmmo:modelGun.bulletCapacity];
            [gun changeCurrentAmmo:modelGun.depotRemain];
            [gun changeCurrentClipAmmo:modelGun.bulletRemain];
            modelGun.aux=gun;
        }
        else if([[[m weaponList] objectAtIndex:j] isMemberOfClass:[M4A1 class]]){
            Weapon* gun=[[Weapon node]initWithType:2];
            [weaponList addObject:gun];
            //init weapon status
            [gun changeClipAmmo:modelGun.bulletCapacity];
            [gun changeCurrentAmmo:modelGun.depotRemain];
            [gun changeCurrentClipAmmo:modelGun.bulletRemain];
            modelGun.aux=gun;
        }
    }
    //default init weapon type
    currentWeaponIndex=0;
    nextWeaponIndex=0;
    NSLog(@"weaponlist count= %d",[weaponList count]);
    //draw all weapon,show current weapon at bottom, others outside the screen
    //sweaponSpriteList=[[NSMutableArray alloc] initWithCapacity: 3];
    for (int i=0; i<[weaponList count]; i++) {
        Weapon* weapon=(Weapon*)[weaponList objectAtIndex:i];
        NSLog(@"add weapon into gamelayer");
        [glayer addChild:weapon.panel];
        
        //###########
        //add aim into layer in advance
        //###########
        [((GameLayer*)glayer).background addChild:weapon.aim z:10];
        //put outside the screen
        weapon.aim.position=ccp(0,-30);
        //store in list for switching positions
        //[weaponSpriteList addObject:weapon];
        if(i==currentWeaponIndex){
            weapon.panel.position=ccp(240,30);
            //pointer to current Weapon, used by changing aim and special shoot
            ((GameLayer*)glayer).currentWeapon=weapon;
        }
        else{
            weapon.panel.position=ccp(240,-30);
        }
    }


}

@end
