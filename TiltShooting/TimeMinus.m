//
//  TimeMinus.m
//  TiltShootingModel
//
//  Created by yirui zhang on 11/16/12.
//
//

#import "TimeMinus.h"
#import "Model.h"

@implementation TimeMinus

- (id) initWithX:(float)x Y:(float)y level:(float)level {
    float time = level;
    float size = SIZE_FORWARD(level);
    if (self = [super initWithX:x Y:y width:size height:size hp:1 bonus:0]) {
        self.time = time;
    }
    return self;
}

- (BOOL) onShootBy:(WeaponBase *)weapon with:(bulletBlock)bullet {
    bullet(weapon, self);
    id<ModelFullInterface> m = [[Model class] instance];
    [m setRemainTime:[m remainTime] - self.time];
    [m deleteTarget:self];
    return YES;
}

- (NSString *) description {
    return [NSString stringWithFormat:@"TimeMinus%@", [super description]];
}

@end
