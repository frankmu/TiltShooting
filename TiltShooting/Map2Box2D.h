//
//  Map2Box2D.h
//  TiltShooting
//
//  Created by yirui zhang on 9/30/12.
//
//
#import <Foundation/Foundation.h>
#import "Target.h"
#import "Bomb.h"
#import "Enemy.h"


@interface Map2Box2D : NSObject

- (void) createWorldWithWidth: (float)width height: (float)height;
- (void) destoryWorld;
- (void) step;
- (void) attachBomb: (Bomb *)bomb;
- (void) attachEnemy: (Enemy *)enemy;
- (void) attachTarget: (Target *)target;
- (void) deleteBomb: (Bomb *)bomb;
- (void) deleteEnemy: (Enemy *)enemy;
- (void) deleteTarget: (Target *)target;
- (Target *) locateTargetByX: (float)x y: (float)y;
@end
