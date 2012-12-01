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
#import "ModelDaemon.h"
#import "TimerTask.h"

@protocol ModelFullInterface <ModelInterface>
@required
/* Fire events */
- (void) fireFlushFinish;
- (void) fireCanvasMoveEvent;
- (void) fireTargetMoveEvent: (Target *)target;
- (void) fireTargetAppearEvent: (Target *)target;
- (void) fireTargetDisappearEvent: (Target *)target;
- (void) fireTargetHitEvent: (Target *)target;
- (void) fireTargetMissEvent: (float)x y:(float)y;
//- (void) fireImpactEvent: (Target *)t1 by: (Target *)t2;
- (void) fireGameInitFinishedEvent;
- (void) firePrepareAppearEvent: (Target*) t time: (NSTimeInterval)time;
- (void) firePrepareDisappearEvent: (Target*) t time: (NSTimeInterval)time;
//- (void) fireWinEvent;
//- (void) fireLoseEvent;
- (void) fireGameFinishEvent;
- (void) fireScoreEvent: (float)score;
- (void) fireBonusEvent: (float)bonus;
- (void) fireTimeEvent: (NSTimeInterval)time;
- (void) fireWeaponStatusChangeEvent: (WeaponBase *)currentWeapon;
- (void) fireNeedReloadEvent;
- (void) fireTargetResizeEvent: (Target *) target;
/* Data Access: notify */
- (void) createTarget: (Target *)target;
- (void) deleteTarget: (Target *)target;
- (void) incScore: (float)score;
- (void) changeTime: (NSTimeInterval)time;
- (void) appear: (Target*)target time:(NSTimeInterval)time;
- (void) disappear: (Target*)target time:(NSTimeInterval)time;
/* Data Access: don't notify */
- (void) setCanvasX: (float)x;
- (void) setCanvasY: (float)y;
- (void) setScore: (float)score;
- (void) setBonus: (float)bonus;
- (void) setTime: (NSTimeInterval)time;
- (void) setRemainTime: (NSTimeInterval)remainTime;
- (void) setCurrentWeapon: (WeaponBase *)weapon;
- (void) updateScoreByBonus:(float) bonus;
- (void) updateScoreByHit: (Target*) t;
- (void) updateScoreByDestroy: (Target*) t;
- (void) incBonus: (float) bonus;
- (Map2Box2D *) map2Box2D;
- (BOOL) shootHappen;
- (BOOL) reloadHappen;
- (int) switchWeaponChange;
- (BOOL) canvasMoved;
- (BOOL) aimMoved;
- (int) currentLevel;
- (void) setAimMoved: (BOOL)aimMoved;
- (void) setCanvasMoved: (BOOL)canvasMoved;
- (void) setReloadHappen: (BOOL)reload;
- (void) resetShootHappen;
- (void) resetSwitchWeaponChange;
- (NSMutableArray *) shootPoints;

- (void) addTimerTask: (NSTimeInterval)time 
                  aux:(id) aux ID:(id)obj block: (timerTaskblock) block;
- (void) refreshTimerTaskList: (NSTimeInterval) time;
- (void) removeTimerTask: (id) obj;
- (ModelDaemon*) daemon;
- (int) combo;

@end
