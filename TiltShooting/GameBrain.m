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
#import "TimePlus.h"
#import "TimeMinus.h"
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
//    id<ModelFullInterface> m = [[Model class] instance];
//    [GameBrain setTotalenemy:level*10];
//    srand((unsigned int) time(NULL));
//    int interval=100/level;
//    for (int i = 0; i < 10*level; ++i) {
//        // gen random float between 0 and canvas board
//        float x = rand()%(int)m.canvasW;
//        float y = rand()%(int)m.canvasH;
//        Enemy *enemy = [[Enemy alloc] initWithX: x Y: y];
//        [m createTarget:enemy];
//        if(rand()%100<=level*20)
//        {
//            float xb=rand()%(interval/2)+pow(-1, rand()%2)*x;
//            float yb=rand()%(interval/2)+pow(-1, rand()%2)*y;
//            if(xb<0)
//                xb=10;
//            else if(xb>=m.canvasW)
//                xb=m.canvasW-10;
//            if(yb<0)
//                yb=10;
//            else if(yb>=m.canvasH)
//                yb=m.canvasW-10;
//            Bomb *bomb = [[Bomb alloc] initWithX: xb Y: yb];
//            [m createTarget:bomb];
//        }
//    }
    
    id<ModelFullInterface> m = [Model instance];
    // init weapon list
    NSMutableArray *weapons = [m weaponList];
    [weapons addObject: [[DesertEagle alloc] init]];
    // init current weapon
    [m setCurrentWeapon: [weapons objectAtIndex:0]];
    // init score system
    [m setScore:0.0f];
    [m setBonus:0.0f];
    [m setTime: 30.0f];
    
    
    int timePulseNumber = 2;
    int timeMinusNumber = 3;
    int enemyNumber = 10;
    
    for (int i = 0; i < timePulseNumber; ++i) {
        float x = rand()%(int)m.canvasW;
        float y = rand()%(int)m.canvasH;
        float time = rand()%10;
        time = time <= 0 ? 1.f : time;
        TimePlus* t = [[TimePlus alloc] initWithX:x Y:y time: time];
        [m createTarget:t];
    }
    
    for (int i = 0; i < timeMinusNumber; ++i) {
        float x = rand()%(int)m.canvasW;
        float y = rand()%(int)m.canvasH;
        float time = rand()%10;
        time = time <= 0 ? 1.f : time;
        TimeMinus* t = [[TimeMinus alloc] initWithX:x Y:y time:time];
        [m createTarget:t];
    }
    
    for (int i = 0; i < enemyNumber; ++i) {
        float x = rand() % (int)m.canvasW;
        float y = rand() % (int)m.canvasH;
        float hp = rand() % 100;
        hp = hp <= 0 ? 5 : hp;
        Enemy* t = [[Enemy alloc] initWithX:x Y:y hp:hp];
        [m createTarget:t];
    }
    
    Enemy* t = [[Enemy alloc] initWithX:720 Y:480 hp:30];
    [m createTarget:t];
}
//
//- (void) randomGenerate: (Class) class number: (int)number {
//    id<ModelFullInterface> m = [Model instance];
//    for (int i = 0; i < number; ++i) {
//        float x = rand()%(int)m.canvasW;
//        float y = rand()%(int)m.canvasH;
//        Class* t = [[Class alloc] initWithX:x Y:y];
//        [m createTarget:t];
//    }
//
//}

+ (void) refreshGameWithLevel:(int)level{
//    id<ModelFullInterface> m = [[Model class] instance];
//    int totalnumber=[GameBrain totalenemy];
//    NSMutableArray * e=[m targetList];
//    srand((unsigned int) time(NULL));
//    int interval=100/level;
//    if(totalnumber>=[e count])
//    {
//        int diff=totalnumber-[e count];
//        if(rand()%100<diff*level)
//        {
//            int num=rand()%diff-1;
//            for (int i = 0; i <num ; ++i) {
//                // gen random float between 0 and canvas board
//                float x = rand()%(int)m.canvasW;
//                float y = rand()%(int)m.canvasH;
//                Enemy *enemy = [[Enemy alloc] initWithX: x Y: y];
//                [m createTarget:enemy];
//                if(rand()%100<=level*10)
//                {
//                    float xb=rand()%interval+pow(-1, rand()%2)*x;
//                    float yb=rand()%interval+pow(-1, rand()%2)*y;
//                    if(xb<0)
//                        xb=10;
//                    else if(xb>=m.canvasW)
//                        xb=m.canvasW-10;
//                    if(yb<0)
//                        yb=10;
//                    else if(yb>=m.canvasH)
//                        yb=m.canvasW-10;
//                    Bomb *bomb = [[Bomb alloc] initWithX: xb Y: yb];
//                    [m createTarget:bomb];
//                }
//            }
//
//        }
//    }
//    if(rand()%100<level*5)
//    {
//        int num=rand()%(level*5);
//        for(int i=0;i<num;i++)
//        {
//            float x = rand()%(int)m.canvasW;
//            float y = rand()%(int)m.canvasH;
//            Bomb *bomb = [[Bomb alloc] initWithX: x Y: y];
//            [m createTarget:bomb];
//        }
//    }
}


@end
