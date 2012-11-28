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
//#import "Bomb.h"
#import "TimeMinus.h"
#import "TimePlus.h"

#define MAX_TIME_BAR 120.0;  //300s
#define MAX_BONUS_BAR 20.0;  

@implementation GameLayer

@synthesize percentage;
@synthesize facebookEnable;
@synthesize viewer;
@synthesize level;
@synthesize background;
@synthesize aimCross;
@synthesize targetList;
@synthesize SheetExplode;
@synthesize SheetExplodeBig;
@synthesize scoreFont;
@synthesize shootMode;
@synthesize timeBar;
@synthesize firstTouchLocation;
@synthesize progressPercentage;
@synthesize progressBar;
@synthesize currentWeapon;
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
        /**  init time bar  */
        
        timeBar=[[TimeProcessBar node] showTimeBarInLayer:self];
        progressBar=[[ProgressBar node] showProgressBar:self];
        //NSLog(@"init gameLayer bg");
		/*
         // indecator
         CCSprite *spriteInd = [CCSprite spriteWithFile:@"enemy.png" rect:CGRectMake(0,0,40,40)];
         [self addChild:spriteInd z:1 tag:5];
         
         spriteInd.scale = 0.8;
         spriteInd.position = ccp(20, 300);
         */
        firstTouchLocation=ccp(0,0);
        //show scoreFont
        CCLabelBMFont *scoreLabel=[CCLabelBMFont labelWithString:@"Score:" fntFile:@"font09.fnt"];
        scoreLabel.position=ccp(30,305);
        scoreLabel.scale = 0.8;
        [self addChild:scoreLabel];
		scoreFont = [CCLabelBMFont labelWithString:@"0" fntFile:@"font09.fnt"];
		scoreFont.anchorPoint = ccp(0, 0);
		scoreFont.scale = 0.8;
		[self addChild:scoreFont z:1 tag:6];
		scoreFont.position = ccp(70, 290);
		
        //creat the aim cross sprite
        //aimCross=[CCSprite spriteWithFile:@"aimcross.png"];
        //aimCross.position =  ccp( size.width /2 , size.height/2 );
        //[self addChild:aimCross z:1 tag:1];
        //[Viewer NSLogDebug:self.debug withMsg:@"init gameLayer aimcross"];
        //init back to menu button
        [CCMenuItemFont setFontSize:30];
		CCMenuItem *backToMenu = [CCMenuItemFont itemFromString:@"Menu" target:self selector:@selector(onBackToMenu:)];
		CCMenu *mn = [CCMenu menuWithItems:backToMenu, nil];
		[mn alignItemsVertically];
		mn.position = ccp (480 - 50, 30);
        
		[self addChild:mn z:1 tag:2];        // add the label as a child to this Layer
        
		//cache explode animation by init viewer
        viewer=[[Viewer alloc] initWithLayer:self];
        
        //select shoot mode button
        CCMenuItem *shootModeButton = [CCMenuItemFont itemFromString:@"     " target:self selector:@selector(changeShootMode:)];
		CCMenu *mn2= [CCMenu menuWithItems:shootModeButton, nil];
        [self addChild:mn2 z:1];
		mn2.position = ccp (100, 30);
        
        shootMode=[CCSprite spriteWithFile:@"bullet_single_multi.png"   rect:CGRectMake(0, 0,50,50)];
        [self addChild:shootMode z:2];
        shootMode.position=ccp(100,30);
        
        //preload sound effetc
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"Rifle_GunShot.mp3"];
		[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"bgmusic1_15s.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"explode.mp3"];
        //show weapon
        //[Viewer showWeapon:self];
        // register to model event listener
        id<ModelInterface>  model = [[Model class] instance];
        [model addToCoreEventListenerList:self];
        
		//debug
        [self setDebug:YES];
        
        //**********  test accelermetor shake temp*********/
        UIAccelerometer *accelerometer=[UIAccelerometer sharedAccelerometer];
        accelerometer.updateInterval=1.0/60.0;
        accelerometer.delegate = self;
        self.shakeonce=FALSE;
        self.currentTime=0.f;
        self.shakeStartTime=0.f;
        [self scheduleUpdate];
	}
	return self;
}
//********************test shake temp********************/
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    float THRESHOLD = 2;
    float timeGap=1;
    
    if (fabs(acceleration.x) > THRESHOLD ||fabs(acceleration.y) > THRESHOLD ||fabs(acceleration.z)> THRESHOLD )
    {
        
        NSLog(@"Accelermeter shake happen once");
        if(!self.shakeonce){
            //haven't shaken
            self.shakeStartTime=self.currentTime;
            self.shakeonce=TRUE;
            //shake
            //[Viewer showBigSign:@"Reload once" inLayer:self withDuration:0.5];
            [[Model instance] setReloadHappen:YES];
            NSLog(@"excute shake once");
        }
        else {
            
            float now=self.currentTime;
            if(now-self.shakeStartTime>=timeGap){
                
                self.shakeonce=FALSE;
                
            }
        }
    }
}
-(void) update:(ccTime)deltaTime {
    self.currentTime += deltaTime;
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
    
    //set shoot mode: default single shoot
    [self setMultiShoot:NO];
    // Enable touch
    [self setIsTouchEnabled:YES];
    [Viewer NSLogDebug:self.debug withMsg:@"enable gameLayer touch"];
    
	
}
//on exit
-(void) onExit{
    
    [super onExit];
    //remove from listenlist of model?
    /* not stop here
     //stop model
     id<ModelInterface> model = [[Model class] instance];
     if (model.status == RUNNING || model.status==PAUSING) {
     [Viewer NSLogDebug:self.debug withMsg:@"gameLayer stops model"];
     [model stop];
     }
     */
    [Viewer NSLogDebug:self.debug withMsg:@"Exit gameLayer"];
}

//Back to menu
-(void)onBackToMenu:(id)sender{
    //pause
    id<ModelInterface>  model = [[Model class] instance];
    NSLog(@"onbacktomenu pause the model for ingamememu display");
    [model pause];
    [self setIsTouchEnabled:NO];
    
    [(InGameMenuLayer*)self.inGameMenuLayer initWithGameLayer:self];
    
    //CCScene *sc = [MenuScene node];
    //[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:sc withColor:ccWHITE]];
}
//temp show gameover scene
-(void)showGameOverScene:(id)sender{
    //will change this to model listen func
    //check win or lose
    //if win
    [Viewer showBigSign:@"WIN!" inLayer:self withDuration:1.5];
    //if lose
    //[Viewer showBigSign:@"LOSE!" inLayer:self withDuration:1];
    
    //stop model here
    id<ModelInterface>  model = [[Model class] instance];
    [model stop];
    //replace scene
    CCScene *sc = [GameOverScene node];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:2.0 scene:sc withColor:ccWHITE]];
    
}

-(void)removeChildFromParent:(CCNode*)child{
    [child removeFromParentAndCleanup:YES];
}
//change shoot mode , show button animation
-(void) changeShootMode:(id)sender{
    CCSpriteBatchNode *shootModeSheet = [CCSpriteBatchNode batchNodeWithFile:@"bullet_single_multi.png" capacity:2];
    [self addChild:shootModeSheet];
    CCAnimation *ans = [CCAnimation animationWithFrames:nil  delay:0.2f];
    if(self.multiShoot){ //change to single
        NSLog(@"change to single shoot mode");
        [self setMultiShoot:NO];
        [Viewer showBigSign:@"Single Shoot" inLayer:self withDuration:1];
        [self.shootMode  setDisplayFrame:[CCSpriteFrame frameWithTextureFilename:@"bullet_single_multi.png" rect:CGRectMake(0, 0, 50, 50)]];
        [self.shootMode runAction:[CCSequence actions:[CCScaleTo actionWithDuration:0.3 scale:1.3],[CCScaleTo actionWithDuration:0.5 scale:1], nil]];
        
        
    }
    else{ //change to multi
        NSLog(@"change to single shoot mode");
        [self setMultiShoot:YES];
        [Viewer showBigSign:@"Multi Shoot" inLayer:self withDuration:1];
        [self.shootMode  setDisplayFrame:[CCSpriteFrame frameWithTextureFilename:@"bullet_single_multi.png" rect:CGRectMake(50, 0, 50, 50)]];
        [self.shootMode runAction:[CCSequence actions:[CCScaleTo actionWithDuration:0.3 scale:1.3],[CCScaleTo actionWithDuration:0.5 scale:1], nil]];
    }
    
    
}
//change score appear on the screen
-(void) changeScore:(float)score{
    
    [self.scoreFont setString:[NSString stringWithFormat:@"%d",(int)score]];
    
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
    
    // get location of touch
    firstTouchLocation = [touch locationInView:[touch view]];
    firstTouchLocation = [[CCDirector sharedDirector] convertToGL:firstTouchLocation];
    NSLog(@"first touch location x=%f y=%f",firstTouchLocation.x,firstTouchLocation.y);
    
    
    //#################
    //need check remain ammo
    //#################
    if(self.multiShoot){
        [self fireWeapon];//at least fire once
        //#################
        //set multshoot frequency based on weapon type
        //#################
        [self schedule:@selector(fireWeapon) interval:0.15];
    }
    else{//single shoot mode
        
        [self schedule:@selector(fireWeapon) interval:0.1 repeat:0 delay:0];
    }
    return YES;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    //temp for debug
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    CGPoint prelocation = [touch previousLocationInView:[touch view]];
    prelocation = [[CCDirector sharedDirector] convertToGL:prelocation];
    if(location.x!=prelocation.x || location.y!=prelocation.y ){
        //if swap, stop fire
        [self unschedule:@selector(fireWeapon)];
        
    }else{
        
        NSLog(@"error in touch move");
    }
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [Viewer NSLogDebug:self.debug withMsg:@"touch ended once"];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    //caculate distance for swap
    float distance=sqrt((location.x-firstTouchLocation.x)*(location.x-firstTouchLocation.x)+(location.y-firstTouchLocation.y)*(location.y-firstTouchLocation.y));
    if(distance>50){
        //valid swipe
        if (location.x-firstTouchLocation.x<0) {
            NSLog(@"swipe for previous weapon");
            [Viewer showBigSign:@"Previous Weapon" inLayer:self withDuration:1];
            //#################
            //change model weapon
            //#################
            [viewer showPreviousWeapon];
        }
        else if(location.x-firstTouchLocation.x>0){
            NSLog(@"swipe for next weapon");
            [Viewer showBigSign:@"Next Weapon" inLayer:self withDuration:1];
            //#################
            //change model weapon
            //#################
            [viewer showNextWeapon];
        }
    }
    firstTouchLocation=ccp(0,0);
    if(self.multiShoot){
        //[self fireWeapon];//at least fire once
        [self unschedule:@selector(fireWeapon)];
    }
    //[[SimpleAudioEngine sharedEngine] playEffect:@"gunShotOntarget.mp3"];
    
}
-(void)fireWeapon{
    //call model
    id<ModelInterface> m = [[Model class] instance];
    [m shoot];
    
    [Viewer NSLogDebug:self.debug withMsg:@"fire gun once"];
    
    
    //#################
    //shoot effect is shown after TargetHit or TargetMiss
    //#################
   //[[SimpleAudioEngine sharedEngine] playEffect:@"Rifle_GunShot.mp3"];
    //show a bullet hole for test, not using location here
   // [Viewer showBulletHole:self atLocation:self.aimCross.position];
    
}


//************Listen to model*******************//
/* target */
- (BUBBLE_RULE) targetAppear: (Target *) target{
    //#################
    //handle target scale
    //#################
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
        case TIMEMINUS:
            //test using bomb
            [Viewer showBomb:target inLayer:self];

            break;
        case TIMEPLUS:
            NSLog(@"show explode on target");
            //[viewer showExplodeInLayer:self at:ccp(target.x,target.y)];
            [Viewer showTimePlus:target inLayer:self];
            break;
   
        default:
            break;
    }
    return BUBBLE_CONTINUE;
}
- (BUBBLE_RULE) targetDisAppear: (Target *) target{
    //for test
    if(target.aux!=nil){
        //check type of target
        TARGET_TYPE type=[self checkTargetType:target];
        switch (type) {
            case AIM:
                
                [Viewer removeAim:target inLayer:self];
                break;
            case ENEMY:
                NSLog(@"show explode on target");
                [viewer showExplodeInLayer:self at:ccp(target.x,target.y)];
                [Viewer removeTarget:target inLayer:self];
                break;
            case BOMB:
                NSLog(@"show explode on target");
                [viewer showExplodeInLayer:self at:ccp(target.x,target.y)];
                [Viewer removeBomb:target inLayer:self];
                break;
            case TIMEMINUS:
                NSLog(@"show explode on target");
                [viewer showExplodeInLayer:self at:ccp(target.x,target.y)];
                [Viewer removeBomb:target inLayer:self];
                break;
            case TIMEPLUS:
                NSLog(@"show explode on target");
                
                [Viewer removeTimePlus:target inLayer:self];
                break;
            default:
                break;
        }
        
        //remove using Viewer now
        
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
//- (BUBBLE_RULE) impact: (Target *) t1 by: (Target *) t2{
//    return BUBBLE_CONTINUE;
    
//}

/* game control signals */
- (BUBBLE_RULE) gameInitFinished{
    id<ModelInterface> m = [[Model class] instance];
    //init time bar
    //#################
    //handle time or bonus overflow
    //#################
    percentage=[m remainTime]/MAX_TIME_BAR;
    [timeBar updateTimeBar:percentage];
    //init bonus bar
    //progressPercentage=[m bonus]/MAX_BONUS_BAR;
    //[progressBar updateProgressBar:progressPercentage];
    
    //init weapon panel
    [viewer initWeaponWithLayer:self];
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
    else if ([target isMemberOfClass:[TimePlus class]]) {
        return TIMEPLUS;
    } else if ([target isMemberOfClass:[TimeMinus class]]){
        return TIMEMINUS;
    }
    return UNKNOWN;
}
- (BUBBLE_RULE) targetMissX: (float)x y:(float)y{
    [[SimpleAudioEngine sharedEngine] playEffect:@"Rifle_GunShot.mp3"];
    
    //show a bullet hole for test, not using location here
    //[Viewer showBulletHole:self atLocation:self.aimCross.position];
    [Viewer showBulletHole:self atLocation:ccp(x,y)];
    return BUBBLE_CONTINUE;
}
- (BUBBLE_RULE) targetHit:(Target *)target {
    //#################
    //handle target blood, shoot effect, sound
    //#################
    [[SimpleAudioEngine sharedEngine] playEffect:@"Rifle_GunShot.mp3"];
    
    if(target.aux!=nil){
        NSLog(@"Target is HITTED");
        //check type of target
        TARGET_TYPE type=[self checkTargetType:target];
        switch (type) {
            case ENEMY:
                
                [Viewer hitTarget:target inLayer:self];
                break;
           /* case BOMB:
                NSLog(@"show explode on target");
                [viewer showExplodeInLayer:self at:ccp(target.x,target.y)];
                [Viewer removeBomb:target inLayer:self];
                break;
            case TIMEMINUS:
                NSLog(@"show explode on target");
                [viewer showExplodeInLayer:self at:ccp(target.x,target.y)];
                [Viewer removeBomb:target inLayer:self];
                break;
            case TIMEPLUS:
                NSLog(@"show explode on target");
                
                [Viewer removeTimePlus:target inLayer:self];
                break;*/
            default:
                break;
        }
    }
    return BUBBLE_CONTINUE;
}
//update weapon status
- (BUBBLE_RULE) weaponStatusChanged:(WeaponBase *)weapon{
    //#################
    //change weapon status
    //#################
    if(weapon.aux!=nil){
        [viewer changeWeaponStatus:weapon];
        //update special skill bar
        progressPercentage=weapon.mana/weapon.skillMana;
        [progressBar updateProgressBar:progressPercentage];
    }
    return BUBBLE_CONTINUE;
}
- (BUBBLE_RULE) time: (float)time{
    //ceil time
    percentage=time/MAX_TIME_BAR;
    //NSLog(@"left time:%f",time);
    [timeBar updateTimeBar:percentage];
    return BUBBLE_CONTINUE;
    
}
- (BUBBLE_RULE) score:(float)score {
    NSLog(@"score change to: %f", score);
    //update score
    [self setScore:score];
    //change score on screen
    [self changeScore:score];
    return BUBBLE_CONTINUE;
}
- (BUBBLE_RULE) bonus:(float)bonus {
    NSLog(@"change bonus to %f",bonus);
    //now use weapon mana 
   // progressPercentage=bonus/MAX_BONUS_BAR;
   // [progressBar updateProgressBar:progressPercentage];
    return BUBBLE_CONTINUE;
}

- (BUBBLE_RULE) needReload {
    //[self showNotify:@"Need Reload"];
    //#################
    //reload sound
    //#################
    [Viewer showBigSign:@"Reload" inLayer:self withDuration:1];
    return BUBBLE_CONTINUE;
}

- (BUBBLE_RULE) gameFinish{
    
    NSLog(@"Game Finish Time up!");
    [self setIsTouchEnabled:NO];
    if(self.multiShoot){//avoid redundant multi shoot
        [self unschedule:@selector(fireWeapon)];
    }

    [Viewer showBigSign:@"Game Over" inLayer:self withDuration:2];
    //stop model here
    id<ModelInterface>  model = [[Model class] instance];
    //[model stop];
    
    //replace scene
    GameOverScene *sc = [GameOverScene node];
    //pass score to gameoverscene
    [sc setScore:self.score];
    [sc setTime:[model maxTime]];
   
    //[sc setWin:TRUE];
    [sc start];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:2.0 scene:sc withColor:ccWHITE]];
    
    return BUBBLE_CONTINUE;

}


/* win, lose  , not used */
- (BUBBLE_RULE) win {
    NSLog(@"win");
    [self setIsTouchEnabled:NO];
    if(self.multiShoot){//avoid redundant multi shoot
        [self unschedule:@selector(fireWeapon)];
    }
    //if win
    [Viewer showBigSign:@"WIN!" inLayer:self withDuration:2];
    //if lose
    //[Viewer showBigSign:@"LOSE!" inLayer:self withDuration:1];
    
    //stop model here
    id<ModelInterface>  model = [[Model class] instance];
    [model stop];
    
    //replace scene
    GameOverScene *sc = [GameOverScene node];
    //pass score to gameoverscene
    [sc setScore:self.score];
    [sc setWin:TRUE];
    [sc start];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:2.0 scene:sc withColor:ccWHITE]];
    
    return BUBBLE_CONTINUE;
}

- (BUBBLE_RULE) lose {
    NSLog(@"Lose");
    //if win
    //[Viewer showBigSign:@"WIN!" inLayer:self withDuration:1.5];
    //if lose
    [self setIsTouchEnabled:NO];
    if(self.multiShoot){//avoid redundant multi shoot
        [self unschedule:@selector(fireWeapon)];
    }
    [Viewer showBigSign:@"LOSE!" inLayer:self withDuration:2];
    
    //stop model here
    id<ModelInterface>  model = [[Model class] instance];
    [model stop];
    
    //replace scene
    GameOverScene *sc = [GameOverScene node];
    //pass score to gameoverscene
    [sc setScore:self.score];
    [sc setWin:FALSE];
    [sc start];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:2.0 scene:sc withColor:ccWHITE]];
    
    return BUBBLE_CONTINUE;
}


- (BUBBLE_RULE) flushFinish {
    id<ModelInterface> m = [Model instance];
    for (Target* t in [m targetList]) {
        CCNode* node = t.aux;
        node.position = ccp(t.x, t.y);
    }
    return BUBBLE_CONTINUE;
}


@end
