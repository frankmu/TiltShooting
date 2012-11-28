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
#import "CBAimCross.h"
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
    //inverse the mask effect
    if(percentage>=1){
        //ct.percentage=0;
        [specialSkillButton setIsEnabled:YES];
    }
   
       // ct.percentage=(1.0-percentage)*100;
    [ct setPercentage:(1.0-percentage)*100];
    
}
//invoked when special skill button is pressed
-(void) pressSpecialButton:(id)sender{
    //disable button first
    [specialSkillButton setIsEnabled:NO];
    //Trigger Aim animation
    [(CBAimCross*)glayer.currentWeapon.aim runTimeLine:@"BlinkAim"];
    //set special shoot mode flag in layer
    [glayer setSpecialShoot:YES];
    //update process bar
    id<ModelInterface> m = [[Model class] instance];
    //init time bar
    //#################
    //handle time or bonus overflow
    //#################
    float p=[m remainTime]/MAX_TIME_BAR;
    [self updateProgressBar:p];
    
}
@end

