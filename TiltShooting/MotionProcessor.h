//
//  MotionProcessor.h
//  TiltShooting
//
//  Created by yirui zhang on 9/26/12.
//
//

#import <Foundation/Foundation.h>

@interface MotionProcessor : NSObject
@property NSTimeInterval flushInterval;
- (void) start;
- (void) stop;
@end
