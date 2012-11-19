//
//  ModelFullInterface.h
//  TiltShooting
//
//  Created by yirui zhang on 9/27/12.
//
//


#import <Foundation/Foundation.h>
#import "ModelInterface.h"
#import "Map2Box2D.h"
#import "POINT.h"

@protocol ModelFullInterface <ModelInterface>
@required
/* Fire events */
- (void) fireCanvasMoveEvent;
- (void) fireTargetMoveEvent: (Target *)target;
- (void) fireTargetAppearEvent: (Target *)target;
- (void) fireTargetDisappearEvent: (Target *)target;
- (void) fireTargetHitEvent: (Target *)target;
//- (void) fireImpactEvent: (Target *)t1 by: (Target *)t2;
- (void) fireGameInitFinishedEvent;
//- (void) fireWinEvent;
//- (void) fireLoseEvent;
- (void) fireGameFinishEvent;
- (void) fireScoreEvent: (float)score;
- (void) fireTimeEvent: (NSTimeInterval)time;
- (void) fireWeaponStatusChangeEvent: (WeaponBase *)currentWeapon;
- (void) fireNeedReloadEvent;
/* Data Access: notify */
- (void) createTarget: (Target *)target;
- (void) deleteTarget: (Target *)target;
- (void) changeScore: (float)score;
- (void) changeTime: (NSTimeInterval)time;
/* Data Access: don't notify */
- (void) setCanvasX: (float)x;
- (void) setCanvasY: (float)y;
- (void) setScore: (float)score;
- (void) setBonus: (float)bonus;
- (void) setTime: (NSTimeInterval)time;
- (void) setRemainTime: (NSTimeInterval)remainTime;
- (Map2Box2D *) map2Box2D;
- (BOOL) shootHappen;
- (BOOL) reloadHappen;
- (void) setReloadHappen: (BOOL)reload;
- (void) resetShootHappen;
- (NSMutableArray *) shootPoints;

@end
