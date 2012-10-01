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
#import "GameLayer.h"
@interface Viewer : NSObject {
    
}
+(void)NSLogDebug:(BOOL)debug withMsg:(NSString*)message;
+(void) showMenuBackground:(CCLayer*)layer;
+(void) showTarget:(Target*)target inLayer:(CCLayer*)layer;
+(void) showBomb:(Target*)target inLayer:(CCLayer*)layer;
+(void) showAim:(Target*)target inLayer:(CCLayer*)layer;
+(void) showWeapon:(WeaponSprite*)weapon inLayer:(CCLayer*)layer;
//show bullet hole at point on view window
+(void) showBulletHole:(CCLayer*)layer atPoint:(CGPoint)location;
//show bullet hole at location of aimcross
+(void) showBulletHole:(CCLayer*)layer atLocation:(CGPoint)location;
+(CGPoint)viewToCanvas:(CGPoint)location;
@end
