//
//  CBAimCross.h
//  TiltShooting
//
//  Created by yan zhuang on 12-11-25.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCBAnimationManager.h"
@interface CBAimCross : CCNode <CCBAnimationManagerDelegate>{
    
}
@property (nonatomic,strong) CCBAnimationManager* myAnimationManager;
-(void) runTimeLine:(NSString *)name;
@end
