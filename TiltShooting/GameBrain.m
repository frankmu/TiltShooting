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
#import "M4A1.h"
#import "Map2Box2D.h"
static int Totalenemy = 0;

@implementation GameBrain

+ (void) setTotalenemy:(int)enemy{
    Totalenemy=enemy;
}
+ (int) totalenemy{
    return Totalenemy;
}
+ (void) initGameSceneWithLevel: (int) level {
    id<ModelFullInterface> m = [Model instance];
    // init weapon list
    NSMutableArray *weapons = [m weaponList];
    [weapons addObject: [[DesertEagle alloc] init]];
    [weapons addObject:[[M4A1 alloc] init]];
    // init current weapon
    [m setCurrentWeapon: [weapons objectAtIndex:0]];
    // init score system
    [m setScore:0.0f];
    [m setBonus:0.0f];
    [m setTime: 60.0f];
    [GameBrain setTotalenemy:15];
    
    srand((unsigned int) time(NULL));
    for(int i=0;i<[GameBrain totalenemy];i++)
    {
        int percentage=rand()%100;
        if(percentage>0&&percentage<80)
        {
            float x = rand() % (int)m.canvasW;
            float y = rand() % (int)m.canvasH;
            float hp = rand() % 100;
            hp = hp <= 0 ? 5 : hp;
            Enemy* t = [[Enemy alloc] initWithX:x Y:y hp:hp];
            [m createTarget:t];
            NSLog(@"ZInitial target %f %f",x,y);
        }
        else if(percentage<90)
        {
            float x = rand()%(int)m.canvasW;
            float y = rand()%(int)m.canvasH;
            float time = rand()%10;
            time = time <= 0 ? 1.f : time;
            TimePlus* t = [[TimePlus alloc] initWithX:x Y:y time: time];
            [m createTarget:t];
            NSLog(@"ZInitial target %f %f",x,y);
        }
        else {
            float x = rand()%(int)m.canvasW;
            float y = rand()%(int)m.canvasH;
            float time = rand()%10;
            time = time <= 0 ? 1.f : time;
            TimeMinus* t = [[TimeMinus alloc] initWithX:x Y:y time:time];
            [m createTarget:t];
            NSLog(@"ZIntitial target %f %f",x,y);
        }
    }
    
    //Enemy* t = [[Enemy alloc] initWithX:m.canvasW/2 Y:m.canvasH/2 hp:10];
    //[m createTarget:t];
}


+ (void) refreshGameWithLevel:(int)level{
    //NSLog(@"GOTO referesh");

    id<ModelFullInterface> m = [[Model class] instance];
    if ([[m map2Box2D] isLock]) {
        return;
    }
    int totalnumber=[GameBrain totalenemy];
    NSMutableArray * e=[m targetList];
    srand((unsigned int) time(NULL));
    if(totalnumber>[e count])
    {
        int diff=totalnumber-[e count];
        if(rand()%100>level*20+diff*10)
            return;
        int num=rand()%diff;
        for (int i = 0; i <num ; ++i) {
            int percentage=rand()%100;
            if(percentage>0&&percentage<80)
            {
                float x = rand() % (int)m.canvasW;
                float y = rand() % (int)m.canvasH;
                float hp = rand() % 100;
                hp = hp <= 0 ? 5 : hp;
                Enemy* t = [[Enemy alloc] initWithX:x Y:y hp:hp];
                [m createTarget:t];
                NSLog(@"Zadd target %f %f",x,y);
            }
            else if(percentage<90)
            {
                float x = rand()%(int)m.canvasW;
                float y = rand()%(int)m.canvasH;
                float time = rand()%10;
                time = time <= 0 ? 1.f : time;
                TimePlus* t = [[TimePlus alloc] initWithX:x Y:y time: time];
                [m createTarget:t];
                NSLog(@"Zadd target %f %f",x,y);
                
            }
            else {
                float x = rand()%(int)m.canvasW;
                float y = rand()%(int)m.canvasH;
                float time = rand()%10;
                time = time <= 0 ? 1.f : time;
                TimeMinus* t = [[TimeMinus alloc] initWithX:x Y:y time:time];
                [m createTarget:t];
                NSLog(@"Zadd target %f %f",x,y);
                
            }
        }
    }
 
}


@end
