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
    Model *m = [[Model class] instance];
    for (int i = 0; i < 10; ++i) {
        // gen random float between 0 and canvas board
        float x = ((float)arc4random()/RAND_MAX) * m.canvasW;
        float y = ((float)arc4random()/RAND_MAX) * m.canvasH;
        Enemy *enemy = [[Enemy alloc] initWithPositionX: x Y: y];
        [m.enemyList addObject:enemy];
    }
    
    for (int i = 0; i < 10; ++i) {
        // gen random float between 0 and canvas board
        float x = ((float)arc4random()/RAND_MAX) * m.canvasW;
        float y = ((float)arc4random()/RAND_MAX) * m.canvasH;
        Bomb *bomb = [[Bomb alloc] initWithPositionX: x Y: y];
        [m.bombList addObject:bomb];
    }
}

@end
