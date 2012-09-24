//
//  GameLayer.h
//  TiltShooting
//
//  Created by yan zhuang on 12-9-15.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "WeaponSprite.h"
#import "CoreEventListener.h"

@interface GameLayer : CCLayer <CoreEventListener>{
    CCSprite *spriteExplode;
	CCSprite *spriteExplodeBig;
	
	
	
	
	//TankSprite *tank;
	
	//CCTMXTiledMap *gameWorld;
	
	float viewOrgX, viewOrgY, viewOrgZ;
	
	float screenWidth, screenHeight, tileSize;
	
	float mapX, mapY;
	

}
@property(nonatomic,strong) CCSprite *background;   //background pic of main scene
@property(nonatomic,strong) CCSprite *aimCross;     //aim cross in the middle
@property(nonatomic,strong) CCSpriteBatchNode *SheetExplode;   //spritesheet for gun shot explosion
@property(nonatomic,strong) CCSpriteBatchNode *SheetExplodeBig; //spritesheet for target destroyed explosion
@property(nonatomic,strong) NSMutableArray *targetList;   //array stores the targets**********
@property(nonatomic,strong) CCLabelTTF *targetLeft;    //count the left targets******* (CCLabelBMFont )

@property(nonatomic,strong) WeaponSprite *weapon; // guns, no gun yet
// change the position of bg , check bg edges
- (void) setWorldPositionX:(float)x Y:(float)y;

//get acceleration from mainscene, check
-(void) checkMove: (UIAcceleration *)acceleration;
@end
