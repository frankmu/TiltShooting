//
//  GameLayer.m
//  TiltShooting
//
//  Created by yan zhuang on 12-9-15.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "TargetSprite.h"
#import "SimpleAudioEngine.h"
#import "ModelInterface.h"
#import "Model.h"
#import "Aim.h"
#import "Bomb.h"
@implementation GameLayer

@synthesize level;
@synthesize background;
@synthesize aimCross;
@synthesize targetList;
@synthesize SheetExplode;
@synthesize SheetExplodeBig;
@synthesize targetLeft;


// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
        [Viewer NSLogDebug:self.debug withMsg:@"init gameLayer"];

        //viewer draw background 
        //[Viewer showMenuBackground:self];
        CGSize size = [[CCDirector sharedDirector] winSize];
		// Load background 1440*960 ??
		background = [CCSprite spriteWithFile:@"nightsky.png"];
		[self addChild:background z:0 tag:9];
        background.position=ccp( size.width /2 , size.height/2 );
        //NSLog(@"init gameLayer bg");
		/*
		// indecator
		CCSprite *spriteInd = [CCSprite spriteWithFile:@"enemy.png" rect:CGRectMake(0,0,40,40)];
		[self addChild:spriteInd z:1 tag:5];
		
		spriteInd.scale = 0.8;
		spriteInd.position = ccp(20, 300);
		*/
        
        //show how many targets left ??
		targetLeft = [CCLabelTTF labelWithString:@"00" fontName:@"Marker Felt" fontSize:20];
		targetLeft.anchorPoint = ccp(0.0, 1.0);
		targetLeft.scale = 0.8;
		[self addChild:targetLeft z:1 tag:6];
		targetLeft.position = ccp(440, 305);
		
        //creat the aim cross sprite
        //aimCross=[CCSprite spriteWithFile:@"aimcross.png"];
        //aimCross.position =  ccp( size.width /2 , size.height/2 );
        //[self addChild:aimCross z:1 tag:1];
        //[Viewer NSLogDebug:self.debug withMsg:@"init gameLayer aimcross"];
        //init back to menu button
        [CCMenuItemFont setFontSize:20];
		CCMenuItem *backToMenu = [CCMenuItemFont itemFromString:@"Menu" target:self selector:@selector(onBackToMenu:)];
		CCMenu *mn = [CCMenu menuWithItems:backToMenu, nil];
		[mn alignItemsVertically];
		mn.position = ccp (480 - 50, 30);
        
		[self addChild:mn z:1 tag:2];        // add the label as a child to this Layer

        /*
		// Check Game Stae
		[self schedule:@selector(ShowState) interval: 0.5];
		
		// tank
		tank = [TankSprite TankWithinLayer:self imageFile:@"Tank.PNG"];
		[tank setPosition:ccp(20, 20)];
		tank.bIsEnemy = NO;
		*/
        
		// Stroe targets for collision detection?
        // ****Add new target as child of background***
		targetList = [[NSMutableArray alloc] initWithCapacity:8];
		
		/*int i;
		TargetSprite *target;
		
		for (i = 0; i < 1; i++) {
            //create and add a new target
			target= [TargetSprite TargetWithinLayerBackground:self imageFile:@""]; //??
            [targetList addObject:target];
		}*/
        
		//Explosion effects
		// explode1
		SheetExplode = [CCSpriteBatchNode batchNodeWithFile:@"Explode1.png" capacity:10];
		[background addChild:SheetExplode z:0];
		
		CCSprite *spriteExplode = [CCSprite spriteWithTexture:SheetExplode.texture rect:CGRectMake(0,0,23,23)];
		[SheetExplode addChild:spriteExplode z:1 tag:5];
		spriteExplode.position = ccp(240, 160);
		[spriteExplode setVisible:NO];
        
		// explode2
		SheetExplodeBig = [CCSpriteBatchNode batchNodeWithFile:@"exploBig.png" capacity:15];
		[background addChild:SheetExplodeBig z:0];
		
		CCSprite *spriteExplodeBig = [CCSprite spriteWithTexture:SheetExplodeBig.texture rect:CGRectMake(0,0,40,40)];
		[SheetExplodeBig addChild:spriteExplodeBig z:1 tag:5];
		spriteExplodeBig.position = ccp(240, 160);
		[spriteExplodeBig setVisible:NO];
		
        //preload sound effetc
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"Rifle_GunShot.mp3"];
		[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"bgmusic1_15s.mp3"];
        //show weapon
        //[Viewer showWeapon:self];
        // register to model event listener
        id<ModelInterface>  model = [[Model class] instance];
        [model addToCoreEventListenerList:self];
       
		//debug
        [self setDebug:YES];
	}
	return self;
}
//On enter
-(void) onEnter
{
	[super onEnter];
    
	[Viewer NSLogDebug:self.debug withMsg:@"Enter GameLayer"];

    //start model
    [Viewer NSLogDebug:self.debug withMsg:@"start model for model test "];
     id<ModelInterface> model = [[Model class] instance];
    [Viewer NSLogDebug:self.debug withMsg:@"start model"];
    [model start];
    //play bg music
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"bgmusic1_15s.mp3"];
    
    // Enable touch
    [self setIsTouchEnabled:YES];
    [Viewer NSLogDebug:self.debug withMsg:@"enable gameLayer touch"];
    
	
}
//on exit
-(void) onExit{
    [Viewer NSLogDebug:self.debug withMsg:@"Exit gameLayer"];
    [super onExit];
    //remove from listenlist of model?
    
    //stop model
    id<ModelInterface> model = [[Model class] instance];
    if (model.status == RUNNING) {
        [Viewer NSLogDebug:self.debug withMsg:@"gameLayer stops model"];
        [model stop];
    }
}

//Back to menu
-(void)onBackToMenu:(id)sender{
    
    CCScene *sc = [MenuScene node];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:sc withColor:ccWHITE]];
}
-(void)removeChildFromParent:(CCNode*)child{
    [child removeFromParentAndCleanup:YES];
}
//************ Handle GameLayer Touch *******************//
// register to get touches input
-(void) registerWithTouchDispatcher
{
    //NSLog(@"register gamelayer to touch dispatcher");
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    [Viewer NSLogDebug:self.debug withMsg:@"touch began once"];
    /*
     // get location of touch 
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    NSLog(@"x=%f y=%f",location.x,location.y);
     */
    [self schedule:@selector(fireWeapon) interval:0.1 repeat:0 delay:0];
    return YES;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	    
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [Viewer NSLogDebug:self.debug withMsg:@"touch ended once"];
    id<ModelInterface> m = [[Model class] instance];
    [m shoot];
    //[self fireWeapon];//at least fire once
    //[self unschedule:@selector(fireWeapon)];
    //[[SimpleAudioEngine sharedEngine] playEffect:@"gunShotOntarget.mp3"];
    
}
-(void)fireWeapon{
    [Viewer NSLogDebug:self.debug withMsg:@"fire gun once"];
    [[SimpleAudioEngine sharedEngine] playEffect:@"Rifle_GunShot.mp3"];
    
    //[model shoot];
    //show a bullet hole for test
    [Viewer showBulletHole:self atLocation:self.aimCross.position];
    
}


//************Listen to model*******************//
/* target */
- (BUBBLE_RULE) targetAppear: (Target *) target{
    //check type of target
    TARGET_TYPE type=[self checkTargetType:target];
    switch (type) {
        case AIM:
            //model init aimCross position?? now, init in gameLayer above
            [Viewer showAim:target inLayer:self];
            break;
        case ENEMY:
            
            [Viewer showTarget:target inLayer:self];
            break;
        case BOMB:
            
            [Viewer showBomb:target inLayer:self];
            break;

        default:
            break;
    }
    return BUBBLE_CONTINUE;
}
- (BUBBLE_RULE) targetDisAppear: (Target *) target{
    //for test
    if(target.aux!=nil){
        [self removeChild:target.aux cleanup:YES];
    }
    else{
        NSLog(@"error:try to delete nil target");
    }
    return BUBBLE_CONTINUE;

}
- (BUBBLE_RULE) targetMove: (Target *) target{
    //for test
    if(target.aux!=nil){
        CCNode *tg=(CCNode*)target.aux;
        //[Viewer NSLogDebug:self.debug withMsg:[NSString stringWithFormat:@"move target from (%f,%f) to (%f,%f)",tg.position.x,tg.position.y,target.x,target.y]];
        tg.position=ccp(target.x,target.y);
    }
    else{
        NSLog(@"error:try to move nil target");
    }
    return BUBBLE_CONTINUE;

}


/* other object */
- (BUBBLE_RULE) canvasMovetoX:(float)x Y:(float)y {
    [self.background setPosition:ccp(x, y)];
    return BUBBLE_CONTINUE;
}
- (BUBBLE_RULE) impact: (Target *) t1 by: (Target *) t2{
    return BUBBLE_CONTINUE;

}

/* game control signals */
- (BUBBLE_RULE) gameInitFinished{
    return BUBBLE_CONTINUE;

}

//check target type
-(TARGET_TYPE)checkTargetType:(Target*)target{
    if([target isMemberOfClass:[Aim class]]){
        //[Viewer NSLogDebug:self.debug withMsg:@"got an Aim target"];
        return AIM;
    }
    else if([target isMemberOfClass:[Enemy class]]){
        //NSLog(@"got an enemy target");
        return ENEMY;
    }
    else if([target isMemberOfClass:[Bomb class]]){
        return BOMB;
    }
    return UNKNOWN;
}

@end
