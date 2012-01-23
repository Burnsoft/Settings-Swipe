//
//  timerAction.m
//  AppSwipe
//
//  Created by Nicholas Burns on 20/01/2012.
//  Copyright 2011 Burnsoft Ltd. All rights reserved.
//

#import "timerAction.h"
#import "AppDelegate.h"


@implementation timerAction
@synthesize delegate;


- (id)init
{
    self = [super init];
    if (self) {

	}
	return self;
}


-(void) scheduleNotificationForDate:(NSDate*)actionDate chosenURL:(NSString*)chosenURL alertTitle:(NSString*)alertTitle; 
{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.userActionCount ++;

    UILocalNotification *localNotification = [[[UILocalNotification alloc] init] autorelease];
    
    localNotification.fireDate = actionDate;    
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.alertBody = alertTitle;
    localNotification.alertLaunchImage=@"launch_iphone.png";   
    localNotification.applicationIconBadgeNumber = -1;
    localNotification.hasAction = NO;
    NSDictionary *userDict = [NSDictionary dictionaryWithObjectsAndKeys:chosenURL,@"chosenURL", nil];
	localNotification.userInfo = userDict; 
	
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
}


-(void)deleteScheduledNotification:(NSString*)alertString;
{

	UIApplication *app = [UIApplication sharedApplication];
	NSArray *eventArray = [app scheduledLocalNotifications];
	for (int i=0; i<[eventArray count]; i++)
	{
		UILocalNotification* oneEvent = [eventArray objectAtIndex:i];

		if ([oneEvent.alertBody isEqualToString:alertString])
		{
			//Cancelling local notification
			[app cancelLocalNotification:oneEvent];
			break;
		}
	}
	
	
	
}




#pragma mark Memory Management

- (void)dealloc {
	

	self.delegate = nil;
    [delegate release];
	[super dealloc];
}


@end
