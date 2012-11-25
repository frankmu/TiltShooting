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
//the panel picture of weapon
@property (nonatomic,strong) CCNode* panel;
@property int ammo;
@property (nonatomic,strong)CCLabelTTF* currentAmmo;
@property (nonatomic,strong)CCLabelTTF* clipAmmo;
@property (nonatomic,strong)CCLabelTTF* currentClipAmmo;
//the corresponding aim node
@property (nonatomic,strong) CCNode* aim;
@property float radius;

-(void)changeCurrentClipAmmo:(int)value;
-(void)changeClipAmmo:(int)value;
-(void)changeCurrentAmmo:(int)value;
@end
