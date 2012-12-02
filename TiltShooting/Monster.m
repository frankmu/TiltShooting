//
//  Monster.m
//  TiltShooting
//
//  Created by yirui zhang on 11/30/12.
//
//

#import "Monster.h"
#import "Model.h"
#import "GameBrain.h"

@implementation Monster
- (id) initWithX:(float)x Y:(float)y level:(float) level {
    float hp = HP(150, 20, level);
    float bonus = BONUS(10, level);
    float size = SIZE_FORWARD(level);
    if (self = [super initWithX:x Y:y width:size height:size hp:hp bonus:bonus]) {
        self.time = 10.0 / level;
        id<ModelFullInterface> m = [Model instance];
        [m addTimerTask:self.time aux:nil ID:self block:^NSTimeInterval(id aux) {
            id<ModelFullInterface> m = [Model instance];
            int current = [[m targetList] count];
            int max = [GameBrain totalenemy];
            if (current <= max) {
                [m createTarget: [[Enemy alloc] initWithX:self.x Y:self.y level: level]];
            }
            return self.time;
        }];
    }
    return self;
}


- (NSString *) description {
    return [NSString stringWithFormat:@"Monster%@", [super description]];
}
@end
