//
//  MainScence.h
//  TiltShooting
//
//  Created by yan zhuang on 12-9-15.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <UIKit/UIKit.h>


@interface MainScene : CCScene <UIApplicationDelegate>{
    
}
@property (nonatomic, strong) MainScene *myScene;
// Great the mainScene with gameLayer as its child
+(id) ShowScene;

@end
