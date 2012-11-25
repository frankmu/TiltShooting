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
#import "Weapon.h"
#import "GameLayer.h"
@interface Viewer : NSObject {
    
}
+(void)NSLogDebug:(BOOL)debug withMsg:(NSString*)message;
+(void) showMenuBackground:(CCLayer*)layer;
+(void) showTarget:(Target*)target inLayer:(CCLayer*)layer;
+(void) showBomb:(Target*)target inLayer:(CCLayer*)layer;
+(void) showTimePlus:(Target*)target inLayer:(CCLayer*)layer;
+(void) showAim:(Target*)target inLayer:(CCLayer*)layer;
+(void) showWeapon:(WeaponSprite*)weapon inLayer:(CCLayer*)layer;
//show bullet hole at point on view window
+(void) showBulletHole:(CCLayer*)layer atPoint:(CGPoint)location;
//show bullet hole at location of aimcross
+(void) showBulletHole:(CCLayer*)layer atLocation:(CGPoint)location;
+(CGPoint)viewToCanvas:(CGPoint)location;
//show a big sign on view and disapear
+(void) showBigSign:(NSString*)sign inLayer:(CCLayer*)layer withDuration:(ccTime)d;
+(void) removeTimePlus:(Target*)target inLayer:(CCLayer*)layer;
+(void) removeTarget:(Target*)target inLayer:(CCLayer*)layer;
+(void) removeBomb:(Target*)target inLayer:(CCLayer*)layer;
+(void) removeAim:(Target*)target inLayer:(CCLayer*)layer;
+(void) hitTarget:(Target*)target inLayer:(CCLayer*)layer;
//init viewer for cache animation
-(id)initWithLayer:(CCLayer*)layer;
-(void)initWeaponWithLayer:(CCLayer*)layer;
-(void) showExplodeInLayer:(CCLayer*)layer at:(CGPoint)location;
-(void)changeWeaponStatus:(WeaponBase*)weapon;
-(void)showPreviousWeapon;
-(void)showNextWeapon;
@property (nonatomic,strong) CCSpriteBatchNode *spriteSheet;
@property (nonatomic,strong)  CCAnimation *explodeAnim;
@property  NSMutableArray *weaponList;
@property  NSMutableArray *weaponSpriteList;
@property int currentWeaponIndex;
@property int nextWeaponIndex;
@property (weak) CCLayer* glayer;
@end
