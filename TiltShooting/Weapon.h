//
//  Weapon.h
//  TiltShooting
//
//  Created by yan zhuang on 12-10-20.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Weapon : CCNode {
    
}

-(id)initWithType:(int)type;
@property NSString *image;
@property int ammo;
@property int currentAmmo;
@property int clipAmmo;
@property int currentClipAmmo;
@property NSString *aim;
@property float radius;
@end
