//
//  DesertEagle.m
//  TiltShooting
//
//  Created by yirui zhang on 10/30/12.
//
//

#import "DesertEagle.h"

@implementation DesertEagle
- (id) init {
    if (self = [super initWithSpeed:0.1f damage:5.0f
                          skillMana:0.0f price:10.0f bulletCapacity:7]) {
        // do nothing
    }
    return self;
}

@end
