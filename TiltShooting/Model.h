//
//  Model.h
//  TiltShooting
//
//  Created by yan zhuang on 12-9-17.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelInterface.h"
#import "Enemy.h"
#import "Aim.h"

@interface Model : NSObject <ModelInterface>

@property (strong) NSMutableArray *enemyList;
@property (strong) NSMutableArray *bombList;
@property (strong) Aim *aim;
@property NSTimeInterval flushInterval;

@end
