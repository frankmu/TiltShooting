//
//  ModelFullInterface.h
//  TiltShooting
//
//  Created by yirui zhang on 9/27/12.
//
//

#import "ModelInterface.h"
#import <Foundation/Foundation.h>

@protocol ModelFullInterface <ModelInterface>
@required
- (void) fireCanvasMove;
@end
