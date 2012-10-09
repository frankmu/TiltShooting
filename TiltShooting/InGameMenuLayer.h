//
//  InGameMenuLayer.h
//  TiltShooting
//
//  Created by yan zhuang on 12-10-3.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface InGameMenuLayer : CCLayer {
    
}
@property (weak) CCLayer* glayer;

-(id)initWithGameLayer:(CCLayer*)layer;
@end
