//
//  Model.h
//  TiltShooting
//
//  Created by yan zhuang on 12-9-17.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelFullInterface.h"
#import "Map2Box2D.h"

@interface Model : NSObject <ModelFullInterface>
@property float canvasX, canvasY, canvasW, canvasH;
@property float deviceW, deviceH;

@property float volume;
@property float score;
@property NSTimeInterval time;
@property float bonus;

@property (strong, atomic) NSMutableArray *targetList;
@property (strong, atomic) NSMutableArray *weaponList;
@property (strong, atomic) WeaponBase *currentWeapon;
@property (strong, atomic) Aim *aim;
@property (strong) Map2Box2D *map2Box2D;
@property (strong, atomic) NSMutableArray *shootPoints;
@property BOOL shootHappen;


@property NSTimeInterval flushInterval;
@property int hasRecord;
@property STATUS status;
@property BOOL debug;
@end
