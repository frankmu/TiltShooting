//
//  MotionProcessor.h
//  TiltShooting
//
//  Created by yirui zhang on 9/26/12.
//
//

#import <Foundation/Foundation.h>

@interface MotionProcessor : UIResponder
@property NSTimeInterval flushInterval;
- (void) start;
- (void) pause;
- (void) resume;
- (void) stop;
@end
