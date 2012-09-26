//
//  Viewer.h
//  TiltShooting
//
//  Created by yan zhuang on 12-9-18.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TargetSprite.h"
#import "WeaponSprite.h"
@interface Viewer : NSObject {
    
}

+(void) showMenuBackground:(CCLayer*)layer;
+(void) showTarget:(TargetSprite*)target;
+(void) showWeapon:(WeaponSprite*)weapon;

 
@end
