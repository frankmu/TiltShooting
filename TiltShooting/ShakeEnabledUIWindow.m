//
//  ShakeEnabledUIWindow.m
//

#import "ShakeEnabledUIWindow.h"


@implementation ShakeEnabledUIWindow
@synthesize isShakeEnabled;

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
	
    	ShakeDispatcher *  dispatcher = [ShakeDispatcher sharedInstance];
	    [dispatcher motionBegan:motion withEvent:event];
	[super motionBegan:motion withEvent:event];
}


- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
	ShakeDispatcher *  dispatcher = [ShakeDispatcher sharedInstance];
	[dispatcher motionCancelled:motion withEvent:event];
	[super motionCancelled:motion withEvent:event];
}


- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if ( event.subtype == UIEventSubtypeMotionShake )
    {
        // Put in code here to handle shake
		ShakeDispatcher *  dispatcher = [ShakeDispatcher sharedInstance];
		[dispatcher motionEnded:motion withEvent:event];
    }
	
	[super motionEnded:motion withEvent:event];
}

- (BOOL)canBecomeFirstResponder
{ return YES; }



@end
