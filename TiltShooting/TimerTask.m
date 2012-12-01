//
//  TimerTask.m
//  TiltShooting
//
//  Created by yirui zhang on 11/30/12.
//
//

#import "TimerTask.h"

@implementation TimerTask
- (id) initWithTime:(NSTimeInterval)time block:(timerTaskblock)block
                aux:(id)aux ID:(id)obj{
    if (self = [super init]) {
        self.time = time;
        self.block = block;
        self.aux = aux;
        self.ID = obj;
    }
    return self;
}
@end
