//
//  Map2Box2D.h
//  TiltShooting
//
//  Created by yirui zhang on 9/30/12.
//
//

#import "Target.h"
#import "Enemy.h"
#import <Foundation/Foundation.h>

@interface Map2Box2D : NSObject

- (void) createWorldWithWidth: (float)width height: (float)height;
- (void) destoryWorld;
- (void) step;
- (void) attachTarget: (Target *)target;
- (void) deleteTarget: (Target *)target;
- (Target *) locateTargetByX: (float)x y: (float)y;
- (void) setMove:(Target *)target:(float)x:(float) y;
- (void)separateTarget:(Target *) target;
@end
