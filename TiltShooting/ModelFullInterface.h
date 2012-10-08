//
//  ModelFullInterface.h
//  TiltShooting
//
//  Created by yirui zhang on 9/27/12.
//
//

#import "ModelInterface.h"
#import "Map2Box2D.h"
#import "Bomb.h"
#import "Enemy.h"
#import <Foundation/Foundation.h>

typedef struct {
    float x;
    float y;
}POINT;

@protocol ModelFullInterface <ModelInterface>
@required
/* Fire events */
- (void) fireCanvasMoveEvent;
- (void) fireTargetMoveEvent: (Target *)target;
- (void) fireTargetAppearEvent: (Target *)target;
- (void) fireTargetDisappearEvent: (Target *)target;
- (void) fireTargetHitEvent: (Target *)target;
- (void) fireImpactEvent: (Target *)t1 by: (Target *)t2;
- (void) fireGameInitFinishedEvent;
/* Date Access */
- (void) createBomb: (Bomb *)bomb;
- (void) createEnemy: (Enemy *)enemy;
- (void) deleteBomb: (Bomb *)bomb;
- (void) deleteEnemy: (Enemy *)enemy;
- (void) setCanvasX: (float)x;
- (void) setCanvasY: (float)y;
- (Map2Box2D *) map2Box2D;
- (BOOL) shootHappen;
- (void) resetShootHappen;
- (POINT) shootPoint;
@end
