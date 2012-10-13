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
static int Totalenemy;

@implementation GameBrain
+ (void) setTotalenemy:(int)enemy{
    Totalenemy=enemy;
}
+ (int) totalenemy{
    return Totalenemy;
}
+ (void) initGameWithLevel: (int) level {
    // version 0
    id<ModelFullInterface> m = [[Model class] instance];
    [GameBrain setTotalenemy:level*30];
    srand((unsigned int) time(NULL));
    int interval=100/level;
    for (int i = 0; i < 20*level; ++i) {
        // gen random float between 0 and canvas board
        float x = rand()%(int)m.canvasW;
        float y = rand()%(int)m.canvasH;
        Enemy *enemy = [[Enemy alloc] initWithX: x Y: y];
        [m createEnemy:enemy];
        if(rand()%100<=level*10)
        {
            float xb=rand()%interval+pow(-1, rand()%2)*x;
            float yb=rand()%interval+pow(-1, rand()%2)*y;	
            if(xb<0)
                xb=10;
            else if(xb>=m.canvasW)
                xb=m.canvasW-10;
            if(yb<0)
                yb=10;
            else if(yb>=m.canvasH)
                yb=m.canvasW-10;
            Bomb *bomb = [[Bomb alloc] initWithX: xb Y: yb];
            [m createBomb:bomb];
        }
    }
}

+ (void) refreshGameWithLevel:(int)level{
    id<ModelFullInterface> m = [[Model class] instance];
    int totalnumber=[GameBrain totalenemy];
    NSMutableArray * e=m.enemyList;
    srand((unsigned int) time(NULL));
    int interval=100/level;
    if(totalnumber>=[e count])
    {
        int diff=totalnumber-[e count];
        if(rand()%100<diff*level)
        {
            int num=rand()%diff-1;
            for (int i = 0; i <num ; ++i) {
                // gen random float between 0 and canvas board
                float x = rand()%(int)m.canvasW;
                float y = rand()%(int)m.canvasH;
                Enemy *enemy = [[Enemy alloc] initWithX: x Y: y];
                [m createEnemy:enemy];
                if(rand()%100<=level*10)
                {
                    float xb=rand()%interval+pow(-1, rand()%2)*x;
                    float yb=rand()%interval+pow(-1, rand()%2)*y;
                    if(xb<0)
                        xb=10;
                    else if(xb>=m.canvasW)
                        xb=m.canvasW-10;
                    if(yb<0)
                        yb=10;
                    else if(yb>=m.canvasH)
                        yb=m.canvasW-10;
                    Bomb *bomb = [[Bomb alloc] initWithX: xb Y: yb];
                    [m createBomb:bomb];
                }
            }

        }
    }
    if(rand()%100<level*5)
    {
        int num=rand()%(level*5);
        for(int i=0;i<num;i++)
        {
            float x = rand()%(int)m.canvasW;
            float y = rand()%(int)m.canvasH;
            Bomb *bomb = [[Bomb alloc] initWithX: x Y: y];
            [m createBomb:bomb];
        }
    }
}

@end
