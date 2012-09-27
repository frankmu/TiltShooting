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
        
        NSLog(@"init gameLayer");
        
        
        //start listen
        
        //viewer draw background
        
        //start model

        CGSize size = [[CCDirector sharedDirector] winSize];
		// Load background 1440*960 ??
		background = [CCSprite spriteWithFile:@"nightsky.png"];
		[self addChild:background z:0 tag:9];
        background.position=ccp( size.width /2 , size.height/2 );
        
        // create and initialize a Label
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Game Layer:can't move, only sound" fontName:@"Marker Felt" fontSize:32];        
		// ask director for the window size
		
        
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2 );
		
		// add the label as a child to this Layer
		[self addChild: label];

        NSLog(@"init gameLayer bg");
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
        aimCross=[CCSprite spriteWithFile:@"aimcross.png"];
        aimCross.position =  ccp( size.width /2 , size.height/2 );
        [self addChild:aimCross z:1 tag:1];
        NSLog(@"init gameLayer aimcross");

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
		
		int i;
		TargetSprite *target;
		
		for (i = 0; i < 1; i++) {
            //create and add a new target
			target= [TargetSprite TargetWithinLayerBackground:self imageFile:@""]; //??
            [targetList addObject:target];
		}
        
		//Explosion effects
		// explode1
		SheetExplode = [CCSpriteBatchNode batchNodeWithFile:@"Explode1.png" capacity:10];
		[background addChild:SheetExplode z:0];
		
		spriteExplode = [CCSprite spriteWithTexture:SheetExplode.texture rect:CGRectMake(0,0,23,23)];
		[SheetExplode addChild:spriteExplode z:1 tag:5];
		spriteExplode.position = ccp(240, 160);
		[spriteExplode setVisible:NO];
        
		// explode2
		SheetExplodeBig = [CCSpriteBatchNode batchNodeWithFile:@"exploBig.png" capacity:15];
		[background addChild:SheetExplodeBig z:0];
		
		spriteExplodeBig = [CCSprite spriteWithTexture:SheetExplodeBig.texture rect:CGRectMake(0,0,40,40)];
		[SheetExplodeBig addChild:spriteExplodeBig z:1 tag:5];
		spriteExplodeBig.position = ccp(240, 160);
		[spriteExplodeBig setVisible:NO];
		
        //preload sound effetc
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"gunShotOntarget.mp3"];
		
        //show weapon
        
        //register to model
        id<ModelInterface> model = [[Model class] instance];
        [model addToCoreEventListenerList:self];
        //start model
        //*************
        //*************
        // Enable touch
		[self setIsTouchEnabled:YES];
		NSLog(@"enable gameLayer touch %d",self.isTouchEnabled);
        
		// Get origenal OpenGL ES view point ??????
		//[[self camera] eyeX:&viewOrgX eyeY:&viewOrgY eyeZ:&viewOrgZ];
		
		/*// init param
		CGSize size = [[CCDirector sharedDirector] winSize];
		screenWidth = size.width;
		screenHeight = size.height;
		
		tileSize = gameWorld.tileSize.width;
		*/
		mapX = 0;
		mapY = 0;
       
	}
	return self;
}
/*
-(void) checkMove: (UIAcceleration *)acceleration{
        
  
}
- (void) setWorldPositionX:(float)x Y:(float)y{
  
}
 */
// register to get touches input
-(void) registerWithTouchDispatcher
{
    NSLog(@"register gamelayer to touch dispatcher");
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"touch began once");
    NSLog(@"for model test only");
    id<ModelInterface> model = [[Model class] instance];
    if (model.status == RUNNING) {
        [model stop];
    } else {
        [model start];
    }
    return YES;
}
-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	    
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"touch ended once");
    id<ModelInterface> model = [[Model class] instance];
    [[SimpleAudioEngine sharedEngine] playEffect:@"gunShotOntarget.mp3"];
    
}

//register to listenerlist of model
//listen to model
- (int) targetAppear: (Target *) target{}
- (int) targetDisAppear: (Target *) target{}
- (int) targetMove: (Target *) target{}

/* other object */
- (int) canvasMovetoX: (float) x Y: (float) y{}
- (int) impact: (Target *) target by: (Target *) target{}

/* game control signals */
- (int) gameInitFinished{}


@end
