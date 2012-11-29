//
//  ModelDaemon.h
//  TiltShooting
//
//  Created by yirui zhang on 9/18/12.
//
//

#import <Foundation/Foundation.h>

@interface ModelDaemon : NSObject
@property NSTimeInterval flushInterval;
- (void) start;
- (void) startWithInterval: (NSTimeInterval) interval;
- (void) stop;
- (void) run: (NSTimeInterval) interval;
@end
