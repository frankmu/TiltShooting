//
//  ModeMenu.m
//  TiltShooting
//
//  Created by yan zhuang on 12-11-28.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "ModeMenu.h"
#import "CCBReader.h"
#import "GameLayer.h"
#import "SimpleAudioEngine.h"
#define BULLETNUM 2

@implementation ModeMenu
@synthesize spriteArray;
@synthesize background;
@synthesize imageArray;
@synthesize facebookMenu;
@synthesize loading;
@synthesize modeMenuButtons;
@synthesize fbMenuButtons;
@synthesize prompt;
@synthesize appDelegate;
-(id)init{
    
    if( (self=[super init] )) {
        NSLog(@"init ModeMenu");
        spriteArray = [[NSMutableArray alloc]init];
        imageArray = [[NSMutableArray alloc]init];
        //preload menubgmusic
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"Rifle_Gunshot.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"menumusic_10s.mp3"];
        
        appDelegate = [[UIApplication sharedApplication] delegate];
    }
    return self;
}
-(void) onEnter
{
	[super onEnter];
    
	NSLog(@"Enter ModeMenu");
    
    //[Viewer showMenuBackground:self];
    
    //play bg music
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"menumusic_10s.mp3" loop:YES];
	// In one second transition to the new scene
	//[self scheduleOnce:@selector(makeTransition:) delay:1];
}
-(void) startNewGame:(id)sender{
    for(int i=0; i<BULLETNUM; i++) {
        [self showBulletHoleOnButton:sender];
    }
    CCScene *scene=[[MainScene node] initWithLevel:1];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:scene withColor:ccWHITE]];

}
-(void) startNewFBGame:(id)sender{
    //clear in case there are asyn image after exit facebook menu
    [imageArray removeAllObjects];
    [spriteArray removeAllObjects];
 
    //show the facebook menu
    CCNode* m=[CCBReader nodeGraphFromFile:@"FBMenuNode.ccbi" owner:self];
    [self addChild:m z:10];
    //position to slide in
    self.facebookMenu=m;
    self.facebookMenu.position=ccp(240,160);
    [self.loading setVisible:NO];
    [self.prompt setVisible:NO];
    //[self.facebookMenu setVisible:NO];
    //[self.facebookMenu setIsTouchEnabled:NO];

  
    [self disableMenu:self.modeMenuButtons];
    //[facebookMenu setIsTouchEnabled:YES];
    //s[self.facebookMenu setVisible:YES];
   // CCAction *slidein=[CCMoveTo actionWithDuration:1.0f position:ccp(0,0)];
    NSLog(@"slide in menu");
   // CCSequence *sequence=[CCSequence actions:
    //                      slidein,[CCCallFuncO actionWithTarget:self selector:@selector(login:) object:nil]
    //                      ,nil];
    //[self.facebookMenu runAction:slidein];
    [self login];
    

    
}
-(void)disableMenu:(CCMenu*)menu{
    for(id m in menu.children){
        if([m isKindOfClass:[CCMenuItemImage class]]){
            NSLog(@"disable one button");
            [(CCMenuItemImage*)m setIsEnabled:NO];
        }
    
    }
}
-(void)enableMenu:(CCMenu*)menu{
    for(id m in menu.children){
        if([m isKindOfClass:[CCMenuItemImage class]]){
            [(CCMenuItemImage*)m setIsEnabled:YES];
        }
        
    }

}
-(void)login{
    NSLog(@"login fb");
    NSLog(@"fb menu position x=%f y=%f",self.facebookMenu.position.x,self.facebookMenu.position.y);
    // The user has initiated a login, so call the openSession method
    // and show the login UX if necessary.
    //   [appDelegate closeSession];
    //    [appDelegate openSessionWithAllowLoginUI:YES];
    
    // If the user is authenticated, log out when the button is clicked.
    // If the user is not authenticated, log in when the button is clicked.
  //  if (FBSession.activeSession.isOpen) {
  //      [appDelegate closeSession];
   // } else {
        // The user has initiated a login, so call the openSession method
        // and show the login UX if necessary.
        appDelegate.flag = nil;
        appDelegate.layer = nil;
        [appDelegate openSessionWithAllowLoginUI:YES];
      //   }
    //download pic
    //[self loadPicture:nil];

}
-(void) loadPicture:(id)sender{
    [self.loading setVisible:YES];
    [self.prompt setVisible:NO];
    // Query to fetch the active user's friends, limit to 5.
    NSString *query =
    @"SELECT uid, name, pic_square FROM user WHERE uid IN "
    @"(SELECT uid2 FROM friend WHERE uid1 = me() LIMIT 5)";
    // Set up the query parameter
    NSDictionary *queryParam =
    [NSDictionary dictionaryWithObjectsAndKeys:query, @"q", nil];
    // Make the API request that uses FQL
    [FBRequestConnection startWithGraphPath:@"/fql"
                                 parameters:queryParam
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
                              if (error)
                              {
                                  NSLog(@"Error: %@", [error localizedDescription]);
                                  NSLog(@"Something wrong with pic downlaoding");
                              }
                              else
                              {
                                  //NSLog(@"Result: %@", result);
                                  NSArray *friendInfo = (NSArray *) [result objectForKey:@"data"];
                                  
                                  for(int i=0; i<friendInfo.count; i++)
                                  {
                                      NSString *friendName = [[friendInfo objectAtIndex:i]objectForKey:@"name"];
                                      NSLog(@"Name %d : %@", i, friendName);
                                      
                                      NSString *friendImg = [[friendInfo objectAtIndex:i]objectForKey:@"pic_square"];
                                      NSLog(@"Name %d : %@", i, friendImg);
                                      
                                      UIImage *image = [UIImage imageWithData:
                                                        [NSData dataWithContentsOfURL:
                                                         [NSURL URLWithString:
                                                          [friendImg stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]]]];
                                      [imageArray addObject:image];
                                      // Create paths to output images
                                      NSString *fileName = [NSString stringWithFormat:@"Test%d.png", i];
                                      NSString  *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:fileName];
                                      //add sprites and names to layer
                                      CCSprite* pic=[CCSprite spriteWithCGImage:image.CGImage key:fileName];
                                      CCLabelTTF* name=[CCLabelTTF labelWithString:friendName fontName:@"Marker Felt" fontSize:19];
                                      [spriteArray addObject:pic];
                                      [self.facebookMenu addChild:pic];
                                      [self.facebookMenu addChild:name];
                                      pic.position=ccp(-180,100-15-i*50);
                                      name.position=ccp(-80,100-15-i*50);
                                      //hide loading font
                                      if(i==friendInfo.count-1){
                                          //last one
                                          [self.loading setVisible:NO];
                                      }
                                      NSLog(@"Count: %d!", [spriteArray count]);
                                      
                                 /*     // Write image to PNG
                                      [UIImagePNGRepresentation(image) writeToFile:pngPath atomically:YES];
                                      
                                      // Create file manager
                                      NSError *error;
                                      NSFileManager *fileMgr = [NSFileManager defaultManager];
                                      
                                      // Point to Document directory
                                      NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"."];
                                      
                                      // Write out the contents of home directory to console
                                      NSLog(@"Documents directory: %@", [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error]);
                                */  
                                  
                                  }
                                  
                              }
                          }];
    NSLog(@"Loading requset finished");
    
}

//not used
-(void) setOptions:(id)sender{
    
    NSLog(@"I'm entered!");
    NSLog(@"Count: %d!", [spriteArray count]);
    for(int i=0; i<[spriteArray count]; i++)
    {
        NSLog(@"I'm entered too!");
        
        CCSprite *temp = [spriteArray objectAtIndex:i];
        [self.background addChild:temp z:10];
        temp.position=ccp(i*20,i+100);
        
        NSLog(@"add target at x=%d y=%d",i*20,i+100);
    }
}
-(void) startFBGame:(id)sender{
    if(imageArray.count>0){
        //FB
        for(int i=0; i<BULLETNUM; i++) {
            [self showBulletHoleOnButton:sender];
        }
        CCScene *scene=[[MainScene node] initWithLevel:1 withFBInfo:imageArray];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:scene withColor:ccWHITE]];
    }
    else{
    //haven't downloading the pictures
        NSLog(@"NO pictures");
        [self.prompt setVisible:YES];
    }
    

}
//invoked to return to main menu
- (void) onBack:(id) sender
{
    CCScene* mainScene = [CCBReader sceneWithNodeGraphFromFile:@"MainMenu.ccbi"];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:mainScene withColor:ccWHITE]];
}
//invoked to return to mode menu
-(void) facebookMenuOnBack:(id)sender{
    //slide out and remove in order to refresh 
   /*CCAction *slidein=[CCMoveTo actionWithDuration:0.5 position:ccp(720,160)];
    CCSequence *sequence=[CCSequence actions:
     slidein,[CCCallFuncO actionWithTarget:self selector:@selector(finishBack:) object:facebookMenu]
              ,nil];
    [self.facebookMenu runAction:sequence];*/
           //remove array
    [self.facebookMenu removeFromParentAndCleanup:YES];
    //[self.modeMenuButtons setIsTouchEnabled:YES];
    [self enableMenu:self.modeMenuButtons];
    [imageArray removeAllObjects];
    [spriteArray removeAllObjects];
    

}
-(void)finishBack:(id)object{
    //self.facebookMenu.position=ccp(0,0);
    //[self.facebookMenu setVisible:NO];
    //[object removeAllChildrenWithCleanup:YES];
    [self setIsTouchEnabled:YES];

}
//show bullet holes effect on a button
-(void) showBulletHoleOnButton:(CCMenuItemImage*)button{
    //randomly show a bullet hole
    
    float w = CCRANDOM_MINUS1_1() * button.contentSize.width/2;  //((float)arc4random()/RAND_MAX)-0.5)
    float h = CCRANDOM_MINUS1_1() * button.contentSize.height/2;
    //? seems menu treat center as (0,0)
    [Viewer showBulletHole:self atPoint:ccp(button.position.x+w+240,button.position.y+h+160)];
    //NSLog(@"show bullet at menulayer x=%f, y=%f",button.position.x+w+240,button.position.y+h+160);
    // NSLog(@"show bullethole at x=%f y=%f",button.position.x+w+240,button.position.y+h+160);
    [[SimpleAudioEngine sharedEngine] playEffect:@"Rifle_GunShot.mp3"];
}

@end
