//
//  ShakeDispatcher.m
//

#import "ShakeDispatcher.h"


static ShakeDispatcher * sharedShakeDispatcherSingleton = NULL;

@implementation ShakeDispatcher
@synthesize processEvents;

- (id)init
{
	if (( self = [super init] )) {		 
		processEvents = YES;
		shakeHandlers = [[NSMutableArray alloc] initWithCapacity:8];
	}
	
	return self;
}



+ (ShakeDispatcher *)sharedInstance {
	@synchronized(self) {
		if ( sharedShakeDispatcherSingleton == nil) {
			[[self alloc] init]; // assignment not done here
		}
	}
	return  sharedShakeDispatcherSingleton;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if ( sharedShakeDispatcherSingleton == NULL) {
			 sharedShakeDispatcherSingleton = [super allocWithZone:zone];
			// assignment and return on first allocation
			return  sharedShakeDispatcherSingleton;
		}
	}
	// on subsequent allocation attempts return nil
	return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}		
	
-(void) removeAllShakeHandlers
{
	if(shakeHandlers == NULL)
	{
		return;
	}
	[shakeHandlers removeAllObjects];	
}
	
-(void) addShakeListener:(id) protocolClass
{
	
	if([protocolClass conformsToProtocol:@protocol(ShakeEventListenerProtocol)])
	{
		if(shakeHandlers !=NULL)
		{
			[shakeHandlers addObject:protocolClass];
		}
	}
}

-(void) removeShakeHandler:(id)handler
{
	if(handler == NULL)
		return;
	
	for( id tmpHandler in shakeHandlers ) {
		if( tmpHandler ==  handler ) {
			[shakeHandlers removeObject:handler];
			break;
		}
	}
	
}


- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
        for(id tmpObject in shakeHandlers)
		{
			if([tmpObject conformsToProtocol:@protocol(ShakeEventListenerProtocol)])
			{
				[tmpObject motionEnded:motion withEvent:event];
			}
		}	
}


- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
	for(id tmpObject in shakeHandlers)
	{
		if([tmpObject conformsToProtocol:@protocol(ShakeEventListenerProtocol)])
		{
			[tmpObject motionBegan:motion withEvent:event];
		}
	}	
}


- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
	for(id tmpObject in shakeHandlers)
	{
		if([tmpObject conformsToProtocol:@protocol(ShakeEventListenerProtocol)])
		{
			[tmpObject motionCancelled:motion withEvent:event];
		}
	}	
}
		
@end
