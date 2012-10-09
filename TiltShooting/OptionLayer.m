//
//  MyCocos2DClass.m
//  TiltShooting
//
//  Created by Michael Ma on 12-9-29.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "OptionLayer.h"
#import "SimpleAudioEngine.h"

@implementation OptionLayer

@synthesize bar;
@synthesize barItem;

- (id) init
{
        self = [super init];
        if (self) {
            CCSprite *bg = [CCSprite spriteWithFile:@"help_background.png"];
            bg.anchorPoint = CGPointZero;
            [self addChild:bg z:-1 tag:0];
            
            [CCMenuItemFont setFontSize:50];
            CGSize winSize = [[CCDirector sharedDirector] winSize];
            
            CCMenuItem *soundAdjust = [CCMenuItemFont itemFromString:@"Sound:"];
 
            CCMenuItemImage *backToMenu = [CCMenuItemImage itemFromNormalImage:@"back1.png" selectedImage:@"back2.png" disabledImage:@"back1.png" target:self selector:@selector(onBack:)];
            
            CCMenu *menu1 = [CCMenu menuWithItems: backToMenu, nil];
            CCMenu *menu2 = [CCMenu menuWithItems: soundAdjust, nil];
            
            menu1.position = ccp (350, 40);
            menu2.position = ccp(winSize.width/2, winSize.height/2 + 80);
//            [menu alignItemsHorizontallyWithPadding:10];
            
            [self addChild: menu1];
            [self addChild: menu2];
            
            //For volume view.
            bar = [CCSprite spriteWithFile:@"bar.png"];
            barItem = [CCSprite spriteWithFile:@"barItem.png"];
        
            bar.position=ccp(winSize.width/2, winSize.height/2);
            barItem.position=ccp(winSize.width/2, winSize.height/2);
            [self addChild:bar z:1 tag:1];
            [self addChild:barItem z:2 tag:2];
            
            [self registerWithTouchDispatcher];
        }
    
     return self;
}

- (void) onBack:(id) sender
{
   
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MenuScene node] withColor:ccWHITE]];
}


/************ Handle OptionLayer Touch *******************/
// register to get touches input
-(void) registerWithTouchDispatcher
{
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    //Get all the touches.
    NSSet *allTouches = [event allTouches];
    
    UITouch *touch1 = [[allTouches allObjects] objectAtIndex:0];
    
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    if (CGRectContainsPoint(bar.boundingBox, location)) {
        
        barItem.position=ccp(location.x, barItem.position.y);
        float volumeNum = (location.x - CGRectGetMinX(bar.boundingBox))/CGRectGetWidth(bar.boundingBox);
        //[CDAudioManager sharedManager].backgroundMusic.volume = volumeNum;
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:volumeNum];
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:volumeNum];
//        id actionTo = [CCMoveTo actionWithDuration: 0.01 position:ccp(location.x, location.y)];
//        [barItem runAction: actionTo];
    }
    
    return YES;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}



@end

