//
//  ProgressBar.h
//  TiltShooting
//
//  Created by Frank Mu on 10/28/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@class GameLayer;
@interface ProgressBar : CCNode {
}
@property (weak) GameLayer* glayer;
@property (nonatomic,strong) CCProgressTimer *ct;
-(id) showProgressBar:(CCLayer*)layer;
-(void)updateProgressBar:(float)percentage;

@end
