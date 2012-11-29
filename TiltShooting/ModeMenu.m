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
-(id)init{
    
    if( (self=[super init] )) {
        NSLog(@"init ModeMenu");
        spriteArray = [[NSMutableArray alloc]init];
        imageArray = [[NSMutableArray alloc]init];
        //preload menubgmusic
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"Rifle_Gunshot.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"menumusic_10s.mp3"];
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

    
    AppController *appDelegate = [[UIApplication sharedApplication] delegate];
    // The user has initiated a login, so call the openSession method
    // and show the login UX if necessary.
    //   [appDelegate closeSession];
    //    [appDelegate openSessionWithAllowLoginUI:YES];
    
    // If the user is authenticated, log out when the button is clicked.
    // If the user is not authenticated, log in when the button is clicked.
    if (FBSession.activeSession.isOpen) {
        [appDelegate closeSession];
    } else {
        // The user has initiated a login, so call the openSession method
        // and show the login UX if necessary.
        [appDelegate openSessionWithAllowLoginUI:YES];
    }
    //show the facebook menu

    self.facebookMenu=(CCLayer*)[CCBReader nodeGraphFromFile:@"FBMenu.ccbi" owner:self];
    [self addChild:facebookMenu z:10];
    //position to slide in
    self.facebookMenu.position=ccp(480,0);
    [self setIsTouchEnabled:NO];
    [facebookMenu setIsTouchEnabled:YES];
    CCAction *slidein=[CCMoveTo actionWithDuration:0.5 position:ccp(0,0)];
    [self.facebookMenu runAction:slidein];

    //download pic
    [self loadPicture];
}
-(void) loadPicture{
    
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
                                      pic.position=ccp(60,260-15-i*50);
                                      name.position=ccp(160,260-15-i*50);
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
    NSLog(@"Loading finished !!!!!");
    
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
    //FB
    for(int i=0; i<BULLETNUM; i++) {
        [self showBulletHoleOnButton:sender];
    }
    CCScene *scene=[[MainScene node] initWithLevel:1 withFBInfo:imageArray];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:scene withColor:ccWHITE]];

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
    CCAction *slidein=[CCMoveTo actionWithDuration:0.5 position:ccp(480,0)];
    CCSequence *sequence=[CCSequence actions:
     slidein,[CCCallFuncO actionWithTarget:self selector:@selector(removeChildFromParent:) object:facebookMenu]
              ,nil];
    [self.facebookMenu runAction:sequence];
           //remove array
    [imageArray removeAllObjects];
    

}
-(void)removeChildFromParent:(id)object{
    [object removeAllChildrenWithCleanup:YES];
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
