//
//  CBAimCross.m
//  TiltShooting
//
//  Created by yan zhuang on 12-11-25.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "CBAimCross.h"


@implementation CBAimCross
@synthesize myAnimationManager;
//invoked after ccb loaded
- (void) didLoadFromCCB
{
    // Setup a delegate method for the animationManager of the CBTarget
    CCBAnimationManager* animationManager = self.userObject;
    animationManager.delegate = self;
    self.myAnimationManager=animationManager;
}
//invoked after the animation of one timeline finished
- (void) completedAnimationSequenceNamed:(NSString *)name
{
    // Remove the explosion object after the animation has finished
    //self.isScheduledForRemove = YES;
    //if([name isEqualToString:@"TargetExplosion"]){
    //    [self removeFromParentAndCleanup:YES];
    //}
}

//run timeline
-(void) runTimeLine:(NSString *)name{
    
    [self.myAnimationManager runAnimationsForSequenceNamed:name];
}

@end
