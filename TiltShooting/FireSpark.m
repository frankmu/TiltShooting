//
//  FireSpark.m
//  TiltShooting
//
//  Created by yan zhuang on 12-11-25.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "FireSpark.h"


@implementation FireSpark
//we will assign the Explosion class to be a delegate of the CCBActionManager that is created when the explosion is loaded. We will do this in the didLoadFromCCB method.
- (void) didLoadFromCCB
{
    // Setup a delegate method for the animationManager of the explosion
    CCBAnimationManager* animationManager = self.userObject;
    animationManager.delegate = self;
}


//Now when the animation finishes playing we will receive a callback, completedAnimationSequenceNamed:. Implement the callback and have it schedule the explosion for removal.
- (void) completedAnimationSequenceNamed:(NSString *)name
{
    // Remove the explosion object after the animation has finished
    //self.isScheduledForRemove = YES;
    [self removeFromParentAndCleanup:YES];
}

@end
