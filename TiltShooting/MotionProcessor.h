//
//  MotionProcessor.h
//  TiltShooting
//
//  Created by yirui zhang on 9/26/12.
//
//

#import <Foundation/Foundation.h>
#import "ShakeEventListenerProtocol.h"
@interface MotionProcessor: NSObject<ShakeEventListenerProtocol>
@property NSTimeInterval flushInterval;
- (void) start;
- (void) pause;
- (void) resume;
- (void) stop;
@end
