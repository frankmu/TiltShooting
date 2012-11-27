//
//  GameBrain.h
//  TiltShooting
//
//  Created by yirui zhang on 9/18/12.
//
//

#import <Foundation/Foundation.h>

@interface GameBrain : NSObject

+ (void) initGame;
+ (void) initGameSceneWithLevel: (int) level;
+ (void) refreshGameWithLevel:(int)level;
@end
