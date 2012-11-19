/*
 *  ShakeEventHandlerProtocol.h
 *
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/**************************
 This protocol basically includes all the methods 
 that iphone 3.0 >= implements for shake.  To make a
 class a shake listener implement the following methods s
 (primarily the motionEnded method) and make sure you add
 yourself as a listener to a shake event
***/ 

@protocol ShakeEventListenerProtocol<NSObject>
 
 - (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event;
 - (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event;
 - (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event;
 @end
 
