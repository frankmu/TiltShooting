//
//  ModelFullInterface.h
//  TiltShooting
//
//  Created by yirui zhang on 9/27/12.
//
//

#import "ModelInterface.h"
#import <Foundation/Foundation.h>

@protocol ModelFullInterface <ModelInterface>
@required
- (void) fireCanvasMoveEvent;
- (void) fireTargetMoveEvent: (Target *)target;
- (void) fireTargetAppearEvent: (Target *)target;
- (void) fireTargetDisappearEvent: (Target *)target;
- (void) fireTargetHitEvent: (Target *)target;
- (void) fireImpactEvent: (Target *)t1 by: (Target *)t2s;
- (void) fireGameInitFinishedEvent;
@end
