//
//  POINT.h
//  TiltShooting
//
//  Created by yirui zhang on 10/31/12.
//
//

#import <Foundation/Foundation.h>

@interface POINT : NSObject
@property float x;
@property float y;
@property BOOL useSkill;

- (id) initWithX: (float)x y: (float)y useSkill: (BOOL)useSkill;
@end
