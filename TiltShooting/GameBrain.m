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
#import "DesertEagle.h"
static int Totalenemy;

@implementation GameBrain

+ (void) setTotalenemy:(int)enemy{
    Totalenemy=enemy;
}
+ (int) totalenemy{
    return Totalenemy;
}
+ (void) initGameSceneWithLevel: (int) level {
    // version 0
    id<ModelFullInterface> m = [[Model class] instance];
    [GameBrain setTotalenemy:level*10];
    srand((unsigned int) time(NULL));
    int interval=100/level;
    for (int i = 0; i < 10*level; ++i) {
        // gen random float between 0 and canvas board
        float x = rand()%(int)m.canvasW;
        float y = rand()%(int)m.canvasH;
        Enemy *enemy = [[Enemy alloc] initWithX: x Y: y];
        [m createTarget:enemy];
        if(rand()%100<=level*20)
        {
            float xb=rand()%(interval/2)+pow(-1, rand()%2)*x;
            float yb=rand()%(interval/2)+pow(-1, rand()%2)*y;
            if(xb<0)
                xb=10;
            else if(xb>=m.canvasW)
                xb=m.canvasW-10;
            if(yb<0)
                yb=10;
            else if(yb>=m.canvasH)
                yb=m.canvasW-10;
            Bomb *bomb = [[Bomb alloc] initWithX: xb Y: yb];
            [m createTarget:bomb];
        }
    }
}

+ (void) refreshGameWithLevel:(int)level{
    id<ModelFullInterface> m = [[Model class] instance];
    int totalnumber=[GameBrain totalenemy];
    NSMutableArray * e=[m targetList];
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
                [m createTarget:enemy];
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
                    [m createTarget:bomb];
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
            [m createTarget:bomb];
        }
    }
}

+ (void) initGame {
    id<ModelFullInterface> m = [[Model class] instance];
    // init weapon list
    NSMutableArray *weapons = [m weaponList];
    [weapons addObject: [[DesertEagle alloc] init]];
    // init current weapon
    [m setCurrentWeapon: [weapons objectAtIndex:0]];
    // init score system
    [m setScore:0.0f];
    [m setBonus:0.0f];
    [m setTime: 30.0f];
}

@end
