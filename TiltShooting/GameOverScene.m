//
//  GameOverScene.m
//  TiltShooting
//
//  Created by yan zhuang on 12-9-17.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameOverScene.h"
#import "SimpleAudioEngine.h"
#import "CCBReader.h"
@implementation GameOverScene
@synthesize background;
@synthesize win;
@synthesize score;
@synthesize time;
@synthesize postParams = _postParams;
@synthesize facebook = _facebook;
@synthesize appDelegate;

-(id)start{
    
    //if( (self=[super init] )) {
    
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    
    CCLayer *scoreLayer=[CCLayer node];
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    
    background = [CCSprite spriteWithFile:@"help_background.png"];
    [scoreLayer addChild:background z:0 tag:0];
    background.position=ccp( size.width /2 , size.height/2 );
    
    CCSprite *blurLayer = [CCSprite spriteWithFile:@"gameover_blur.png"];
    [scoreLayer addChild:blurLayer z:1 tag:1];
    blurLayer.position=ccp( size.width /2 , size.height/1.8 );
    blurLayer.opacity=150;
    blurLayer.scale=1.1;
    
    CCMenuItemImage *retry = [CCMenuItemImage itemFromNormalImage:@"gameover_retry.png" selectedImage:@"gameover_retry_sel.png" disabledImage:nil target:self selector:@selector(retry:)];
    retry.position=ccp(-150,-120);
    //self.retry=retry;
    
    CCMenuItemImage *mainMenu = [CCMenuItemImage itemFromNormalImage:@"gameover_mainmenu.png" selectedImage:@"gameover_mainmenu_sel.png" disabledImage:nil target:self selector:@selector(mainmenu:)];
    mainMenu.position=ccp(0,-120);
    //self.mainMenu=mainMenu;
    
    CCMenuItemImage *postToFB = [CCMenuItemImage itemFromNormalImage:@"gameover_ShareButton.png" selectedImage:@"gameover_ShareButtonSelected.png" disabledImage:nil target:self selector:@selector(posttofb:)];
    postToFB.position=ccp(150,-120);
    
    CCMenu *mn = [CCMenu menuWithItems:retry, mainMenu, postToFB, nil];
    [scoreLayer addChild:mn z:2 tag:2];
    
    //create and initialize a Label
    NSString *state = @"";
    if (win) {
        state=@"You Win!!";
    }else{
        state=@"You Lose.";
    }
    //CCLabelTTF *result = [CCLabelTTF labelWithString:state fontName:@"Zapfino" fontSize:48];
    CCLabelTTF *result = [CCLabelTTF labelWithString:@"Game Over" fontName:@"Zapfino" fontSize:48];
    //position the label on the center of the screen
    result.position =  ccp( size.width /3 , size.height/1.25 );
    [scoreLayer addChild:result z:3 tag:3];
    
    //create and initialize a Label
    CCLabelTTF *scoreFont= [CCLabelTTF labelWithString:@"Score:" fontName:@"Marker Felt" fontSize:48];
    //position the label on the center of the screen
    scoreFont.position =  ccp( size.width /4 , size.height/1.6 );
    [scoreLayer addChild:scoreFont z:4 tag:4];
    
    CCLabelTTF *scoreNumber=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",(int)self.score] fontName:@"Marker Felt" fontSize:48];
    scoreNumber.anchorPoint=ccp(0,0);
    scoreNumber.position =  ccp( size.width /2.8 , size.height/1.9 );
    [scoreLayer addChild:scoreNumber z:5 tag:5];
    //create and initialize a Label
    CCLabelTTF *timeFont = [CCLabelTTF labelWithString:@"Time:" fontName:@"Marker Felt" fontSize:48];
    //position the label on the center of the screen
    timeFont.position =  ccp( size.width /4 , size.height/2.4 );
    [scoreLayer addChild:timeFont z:6 tag:6];
    
    //################
    //cancle total time?
    //################
    CCLabelTTF *totalTime=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%.1f",self.time] fontName:@"Marker Felt" fontSize:48];
    totalTime.anchorPoint=ccp(0,0);
    totalTime.position =  ccp( size.width /2.8 , size.height/3.0);
    [scoreLayer addChild:totalTime z:5 tag:5];
    
    
    [self addChild: scoreLayer z:0 tag:1];
    
    return self;
}

-(void) mainmenu: (id) sender
{
	//CCScene *sc = [MenuScene node];
    CCScene* mainScene = [CCBReader sceneWithNodeGraphFromFile:@"MainMenu.ccbi"];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:mainScene withColor:ccWHITE]];
}
-(void) retry:(id)sender
{
    
    CCScene *scene=[[MainScene node] initWithLevel:1];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:2 scene:scene withColor:ccWHITE]];
}

-(void) posttofb:(id)sender
{
    NSLog(@"I have entered the posttofb");
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    //for fb login part.
    if (!FBSession.activeSession.isOpen)
    {
        appDelegate.flag = @"post";
        appDelegate.layer = self;
        [appDelegate openSessionWithAllowLoginUI:YES];
        
        NSLog(@"FBSession.activeSession is not Open");
    }
    
        //for Facebook post part!
        // Initiate a Facebook instance and properties
        if (FBSession.activeSession.isOpen)
        {
             NSLog(@"FBSession.activeSession is Open");
            
            if (nil == self.facebook) {
                self.facebook = [[Facebook alloc]
                                   initWithAppId:FBSession.activeSession.appID
                                   andDelegate:nil];
                
                // Store the Facebook session information
                self.facebook.accessToken = FBSession.activeSession.accessToken;
                self.facebook.expirationDate = FBSession.activeSession.expirationDate;
            } else {
                // Clear out the Facebook instance
                self.facebook = nil;
            }
        }
        
        NSLog(@"I will post now.");
        // Put together the dialog parameters
        self.postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                             @"TiltShooting", @"name",
                             @"It's developed by Zhuang Yan, Xincheng Ma, Tengfei Mu, Yirui Zhang and Xuming Zhu!", @"caption",
                             [NSString stringWithFormat:@"I have gotten %d scores in TiltShooting! Friends me on Facebook! Let's play together!",(int)self.score], @"description",
                             @"http://www.facebook.com/tiltshooting.ma", @"link",
                             @"http://farm9.staticflickr.com/8482/8238168065_af9e082dec_m.jpg", @"picture",
                             //                      @"https://raw.github.com/fbsamples/ios-3.x-howtos/master/Images/iossdk_logo.png", @"picture",
                             nil];
        // Invoke the dialog
        [self.facebook dialog:@"feed" andParams:self.postParams andDelegate:self];
        
    
}
/**
 * A function for parsing URL parameters.
 */
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [[kv objectAtIndex:1]
         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}

// Handle the publish feed call back
- (void)dialogCompleteWithUrl:(NSURL *)url {
    NSDictionary *params = [self parseURLParams:[url query]];
/*    NSString *msg = [NSString stringWithFormat:
                     @"Posted story, id: %@",
                     [params valueForKey:@"post_id"]];

    NSLog(@"%@", msg);
  */
    
    
    // Show the result in an alert
    [[[UIAlertView alloc] initWithTitle:@"Result"
                                message:@"Cong! Post Success!"
                               delegate:nil
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil]
     show];
}

@end
