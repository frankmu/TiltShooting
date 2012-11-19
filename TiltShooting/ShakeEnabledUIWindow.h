//
//  ShakeEnabledUIWindow.h
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ShakeDispatcher.h"

@interface ShakeEnabledUIWindow  : UIWindow {
    BOOL isShakeEnabled;
}
@property BOOL isShakeEnabled;
@end
