//
//  ShakeDispatcher.h
//

#import <Foundation/Foundation.h>
#import "ShakeEventListenerProtocol.h"


/*
    The dispatcher serves as a singleton that the window
    passes events to.  It distributes those events to attached
    listners (must implement ShakeEventHandlerListenerProtocol)
 
 */

@interface ShakeDispatcher : NSObject<ShakeEventListenerProtocol> {
    NSMutableArray * shakeHandlers;
	BOOL processEvents;
}

/** Whether or not the events are going to be dispatched. Default: YES */
@property (nonatomic,readwrite, assign) BOOL processEvents;

-(void) addShakeListener:(id) protocolClass;
-(void) removeAllShakeHandlers;
-(void) removeShakeHandler:(id)handler;
+(ShakeDispatcher*) sharedInstance;
@end
