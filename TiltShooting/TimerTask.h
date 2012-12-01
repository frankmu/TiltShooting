//
//  TimerTask.h
//  TiltShooting
//
//  Created by yirui zhang on 11/30/12.
//
//

#import <Foundation/Foundation.h>

typedef NSTimeInterval (^timerTaskblock)(id aux);

@interface TimerTask : NSObject
@property (nonatomic, strong) id ID;
@property (nonatomic, strong) id aux;
@property (nonatomic) NSTimeInterval time;
@property (nonatomic, copy) timerTaskblock block;
- (id) initWithTime: (NSTimeInterval)time block: (timerTaskblock)block
                aux:(id) aux ID:(id) obj;
@end
