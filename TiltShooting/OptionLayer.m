//
//  MyCocos2DClass.m
//  TiltShooting
//
//  Created by Michael Ma on 12-9-29.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "OptionLayer.h"
#import "SimpleAudioEngine.h"
#import "CCBReader.h"
@implementation OptionLayer

@synthesize bar1;
@synthesize barItem1;
@synthesize bar2;
@synthesize barItem2;

- (id) init
{
        self = [super init];
        if (self) {
            CCSprite *bg = [CCSprite spriteWithFile:@"help_background.png"];
            bg.anchorPoint = CGPointZero;
            [self addChild:bg z:-1 tag:0];
            
            [CCMenuItemFont setFontSize:20];
            CGSize winSize = [[CCDirector sharedDirector] winSize];
            
            CCMenuItem *soundAdjust = [CCMenuItemFont itemFromString:@"Background:"];
            CCMenuItem *effectAdjust = [CCMenuItemFont itemFromString:@"Effect:"];
            
            CCMenuItemImage *backToMenu = [CCMenuItemImage itemFromNormalImage:@"back1.png" selectedImage:@"back2.png" disabledImage:@"back1.png" target:self selector:@selector(onBack:)];
            
            
            CCMenu *menu1 = [CCMenu menuWithItems: backToMenu, nil];
            CCMenu *menu2 = [CCMenu menuWithItems: soundAdjust, effectAdjust, nil];
            //            CCMenu *menu3 = [CCMenu menuWithItems: effectAdjust, nil];
            [menu2 alignItemsVerticallyWithPadding:30];
            
            menu1.position = ccp (350, 40);
            menu2.position = ccp(50, winSize.height/2);
            //            menu3.position = ccp(40, winSize.height/2 - 30);
            //            [menu alignItemsHorizontallyWithPadding:10];
            
            [self addChild: menu1];
            [self addChild: menu2];
            
            //For volume view.
            bar1 = [CCSprite spriteWithFile:@"bar.png"];
            barItem1 = [CCSprite spriteWithFile:@"barItem.png"];
            bar1.position=ccp(winSize.width/2 + 50, winSize.height/2 + 30);
            barItem1.position=ccp(winSize.width/2 + 50, winSize.height/2 + 30);
            [self addChild:bar1 z:1];
            [self addChild:barItem1 z:2];
            
            bar2 = [CCSprite spriteWithFile:@"bar.png"];
            barItem2 = [CCSprite spriteWithFile:@"barItem.png"];
            bar2.position=ccp(winSize.width/2 + 50, winSize.height/2 - 30);
            barItem2.position=ccp(winSize.width/2 + 50, winSize.height/2 - 30);
            [self addChild:bar2 z:1];
            [self addChild:barItem2 z:2];
            
            [self registerWithTouchDispatcher];
        }
    
     return self;
}

- (void) onBack:(id) sender
{
   CCScene* mainScene = [CCBReader sceneWithNodeGraphFromFile:@"MainMenu.ccbi"];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:mainScene withColor:ccBLACK]];
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
    
    float width = [bar1 boundingBox].size.width;
    float height = [bar1 boundingBox].size.height;
    //    NSLog(@"width: + %f", width);
    //    NSLog(@"height: + %f", height);
    
    float barItemWidth = [barItem1 boundingBox].size.width;
    float leftOfBar1 = bar1.position.x - width * 0.5 + barItemWidth * 0.5;
    float leftOfBar2 = bar2.position.x - width * 0.5 + barItemWidth * 0.5;
    float rightOfBar1 = bar1.position.x + width * 0.5 - barItemWidth * 0.5;
    float rightOfBar2 = bar2.position.x + width * 0.5 - barItemWidth * 0.5;
    float upOfBar1 = bar1.position.y + height * 0.5;
    float upOfBar2 = bar2.position.y + height * 0.5;
    float downOfBar1 = bar1.position.y - height * 0.5;
    float downOfBar2 = bar2.position.y - height * 0.5;
    
    float volumeNum = 0;
    //    if (CGRectContainsPoint(bar1.boundingBox, location)) {
    if (location.y > downOfBar1 && location.y < upOfBar1) {
        if(location.x > leftOfBar1 && location.x < rightOfBar1)
        {
            barItem1.position = ccp(location.x, barItem1.position.y);
            //        float volumeNum = (barItem1.position.x - CGRectGetMinX(bar1.boundingBox))/CGRectGetWidth(bar1.boundingBox);
            volumeNum = (barItem1.position.x - leftOfBar1)/(width - barItemWidth);
        }
        else if(location.x <= leftOfBar1)
        {
            barItem1.position = ccp(leftOfBar1, barItem1.position.y);
            volumeNum = 0;
        }
        else
        {
            barItem1.position = ccp(rightOfBar1, barItem1.position.y);
            volumeNum = 1.0;
        }
        
        //[CDAudioManager sharedManager].backgroundMusic.volume = volumeNum;
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:volumeNum];
    }
    //    else if (CGRectContainsPoint(bar2.boundingBox, location)) {
    else if (location.y > downOfBar2 && location.y < upOfBar2) {
        
        if(location.x > leftOfBar2 && location.x < rightOfBar2)
        {
            barItem2.position = ccp(location.x, barItem2.position.y);
            //        float volumeNum = (barItem1.position.x - CGRectGetMinX(bar1.boundingBox))/CGRectGetWidth(bar1.boundingBox);
            volumeNum = (barItem2.position.x - leftOfBar2)/(width - barItemWidth);
        }
        else if(location.x <= leftOfBar2)
        {
            barItem2.position = ccp(leftOfBar2, barItem2.position.y);
            volumeNum = 0;
        }
        else
        {
            barItem2.position = ccp(rightOfBar2, barItem2.position.y);
            volumeNum = 1.0;
        }
        
        //[CDAudioManager sharedManager].backgroundMusic.volume = volumeNum;
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:volumeNum];
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

