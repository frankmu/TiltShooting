//
//  ProgressBar.m
//  TiltShooting
//
//  Created by Frank Mu on 10/28/12.
//
//

#import "ProgressBar.h"

#import "GameLayer.h"
#import "CCBReader.h"
@implementation ProgressBar
@synthesize glayer;
@synthesize ct;
@synthesize specialSkillButton;

-(id) showProgressBar:(CCLayer*)layer{
    
    glayer=(GameLayer*)layer;
    //CCSprite *background=[CCSprite spriteWithFile:@"processbar.png"];
    
    //specialSkillButton is diabled at first
    CCNode* background=[CCBReader nodeGraphFromFile:@"ProcessBarPanel.ccbi" owner:self];
    CGSize size = [[CCDirector sharedDirector] winSize];
    background.position=ccp( size.width /12 , size.height/10);
    [glayer addChild:background z:20 tag:20];
    
    CCSprite *processbar=[CCSprite spriteWithFile:@"processblur.png"];
    //[processbar setOpacity:200];
    ct=[CCProgressTimer progressWithSprite:processbar];
    [ct setOpacity:180];
    [ct setPosition:ccp( size.width /12 , size.height/10)];
    //ct.barChangeRate=ccp(0.775,0);
    //ct.midpoint=ccp(0,1);
    [ct setPercentage:90];
    [ct setType:kCCProgressTimerTypeRadial];
    ct.percentage+=10;
    [glayer addChild:ct z:21 tag:21];
    return self;
}
-(void)updateProgressBar:(float)percentage{
    
    if(percentage>=1){
        ct.percentage=100;
        [specialSkillButton setIsEnabled:YES];
    }
    else{
        ct.percentage=percentage*100;
    }
    
}
//invoked when special skill button is pressed
-(void) pressSpecialButton:(id)sender{
    //disable button first
    [specialSkillButton setIsEnabled:NO];
    //Trigger Aim animation
    
    //set special shoot mode flag in layer

}
@end

