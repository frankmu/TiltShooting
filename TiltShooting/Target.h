//
//  Target.h
//  TiltShooting
//
//  Created by yirui zhang on 9/17/12.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Target : NSObject {
    @public
    void *box2dAux;
}

@property float x;
@property float y;
@property (weak) id aux;
@property (weak) id intervalAux;

- (id) init;
- (id) initWithX: (float)x Y: (float)y;
- (float) xInDevice;
- (float) yInDevice;
@end
