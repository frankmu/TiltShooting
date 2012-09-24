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
        
        CGSize size = [[CCDirector sharedDirector] winSize];
		// Load background 1440*960 ??
		background = [CCSprite spriteWithFile:@"nightsky.png"];
		[self addChild:background z:0 tag:9];
        background.position=ccp( size.width /2 , size.height/2 );
        
        // create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];
        
		// ask director for the window size
		
        
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2 );
		
		// add the label as a child to this Layer
		[self addChild: label];

        
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
		
		// Enable touch
		[self setIsTouchEnabled:YES];
		
		// Get origenal OpenGL ES view point ??????
		[[self camera] eyeX:&viewOrgX eyeY:&viewOrgY eyeZ:&viewOrgZ];
		
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

-(void) checkMove: (UIAcceleration *)acceleration{
        
    NSLog(@"Acceleration.x= %f, Acceleration.y=%f",acceleration.x,acceleration.y);
#define  kPlayerSpeed 1;
    //CCSprite *aim=[[self getChildByTag:1] aimCross];
    float currentX = aimCross.position.x;
    float currentY = aimCross.position.y;
    float destX,destY,x,y;
    if(acceleration.x > 0.25) {  // tilting the device upwards
        x=- acceleration.y * kPlayerSpeed;
        y=acceleration.x * kPlayerSpeed;
        destX = currentX - acceleration.y * kPlayerSpeed;
        destY = currentY + acceleration.x * kPlayerSpeed;
        // shouldMove = YES;
    } else if (acceleration.x < -0.25) {  // tilting the device downwards
        x=- acceleration.y * kPlayerSpeed;
        y=acceleration.x * kPlayerSpeed;
        destX = currentX - acceleration.y * kPlayerSpeed;
        destY = currentY + acceleration.x * kPlayerSpeed;
        // shouldMove = YES;
    } else if(acceleration.y < -0.25) {  // tilting the device to the right
        x=- acceleration.y * kPlayerSpeed;
        y=acceleration.x * kPlayerSpeed;
        destX = currentX - acceleration.y * kPlayerSpeed;
        destY = currentY + acceleration.x * kPlayerSpeed;
        // shouldMove = YES;
    } else if (acceleration.y > 0.25) {  // tilting the device to the left
        x=- acceleration.y * kPlayerSpeed;
        y=acceleration.x * kPlayerSpeed;
        destX = currentX - acceleration.y * kPlayerSpeed;
        destY = currentY + acceleration.x * kPlayerSpeed;
        //  shouldMove = YES;
    } else {
        destX = currentX;
        destY = currentY;
        
    }
   // aim.position=CGPointMake(destX,destY);
    
   //Move background ????
    [self setWorldPositionX:x Y:y];

   // self.aimCross.position=CGPointMake(aimCross.position.x+acceleration.x, aimCross.position.y+acceleration.y);
}
- (void) setWorldPositionX:(float)x Y:(float)y{
    /*CGRect rc;
	
	rc = [tank textureRect];
	
	// NSLog([NSString stringWithFormat:@"Map Pos - tank.x =  %.2f, tank width = %.2f ", tank.position.x, rc.size.width]);
	
	// Check if the dozer is near the edge of the map
	if(tank.position.x < screenWidth/2 - rc.size.width / 2)
		mapX = 0;
	else if(tank.position.x > [self gameWorldWidth] - (screenWidth / 2))
		mapX = -[self gameWorldWidth];
	else
		mapX = -(tank.position.x - (screenWidth/2) + rc.size.width / 2);
	
	if(tank.position.y < screenHeight/2 - rc.size.height / 2)
		mapY = 0;
	else if(tank.position.y > [self gameWorldHeight] - (screenHeight/2))
		mapY = -[self gameWorldHeight];
	else
		mapY = -(tank.position.y - (screenHeight/2) + rc.size.height / 2);
	
	// Reset the map if the next position is past the edge
	if(mapX > 0) mapX = 0;
	if(mapY > 0) mapY = 0;
	
	if(mapX < -([self gameWorldWidth] - screenWidth)) mapX = -([self gameWorldWidth] - screenWidth);
	if(mapY < -([self gameWorldHeight] - screenHeight)) mapY = -([self gameWorldHeight] - screenHeight);
	
	// [gameWorld setPosition:ccp(mapX, mapY)];
	gameWorld.position = ccp(mapX, mapY);
   */
     background.position=ccp(background.position.x-x,background.position.y-y);
    
    

}
// register to get touches input
-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	
}
-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	    
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	id<ModelInterface> model = [[Model class] instance];
    [[SimpleAudioEngine sharedEngine] playEffect:@"gunShotOntarget.mp3"];
}

@end
