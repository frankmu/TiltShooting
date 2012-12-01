//
//  Model.h
//  TiltShooting
//
//  Created by yan zhuang on 12-9-17.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelFullInterface.h"
#import "ModelDaemon.h"

@interface Model : NSObject <ModelFullInterface>
@property float canvasX, canvasY, canvasW, canvasH;
@property float deviceW, deviceH;

@property float volume;
@property float score;
@property NSTimeInterval remainTime;
@property NSTimeInterval maxTime;
@property float bonus;

@property (strong, atomic) NSMutableArray* targetList;
@property (strong, atomic) NSMutableArray* weaponList;
@property (strong, atomic) NSMutableArray* timerTaskList;
@property (strong, atomic) WeaponBase *currentWeapon;
@property (strong, atomic) Aim *aim;
@property (strong) ModelDaemon *daemon;
@property (strong) Map2Box2D *map2Box2D;
@property (strong, atomic) NSMutableArray *shootPoints;
@property (atomic) BOOL shootHappen;
@property (atomic) BOOL reloadHappen;
@property (atomic) int switchWeaponChange;
@property (atomic) BOOL aimMoved;
@property (atomic) BOOL canvasMoved;
@property (atomic) int currentLevel;
@property (atomic) int combo;


@property NSTimeInterval flushInterval;
@property int hasRecord;
@property STATUS status;
@property BOOL debug;
@end
