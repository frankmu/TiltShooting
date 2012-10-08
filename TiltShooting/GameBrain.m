//
//  GameBrain.m
//  TiltShooting
//
//  Created by yirui zhang on 9/18/12.
//
//

#import "GameBrain.h"
#import "Model.h"
#import "Enemy.h"
#import "Aim.h"
#import "Bomb.h"

@implementation GameBrain

+ (void) initGameWithLevel: (int) level {
    // version 0
    id<ModelFullInterface> m = [[Model class] instance];
    for (int i = 0; i < 10; ++i) {
        // gen random float between 0 and canvas board
        float x = m.canvasW / 10.0f * i + m.canvasW / 20.0f;
        float y = m.canvasH / 10.0f * i + m.canvasH / 20.0f;
        Enemy *enemy = [[Enemy alloc] initWithX: x Y: y];
        [m createEnemy:enemy];
    }
    
    for (int i = 0; i < 10; ++i) {
        // gen random float between 0 and canvas board
        float x = m.canvasW / 10.0f * i + m.canvasW / 30.0f;
        float y = m.canvasH / 10.0f * i + m.canvasH / 30.0f;
        Bomb *bomb = [[Bomb alloc] initWithX: x Y: y];
        [m createBomb:bomb];
    }
}

@end
