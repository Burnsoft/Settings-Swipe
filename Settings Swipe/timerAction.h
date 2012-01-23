//
//  timerAction.h
//  AppSwipe
//
//  Created by Nicholas Burns on 20/01/2012.
//  Copyright 2011 Burnsoft Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol timerActionDelegate <NSObject>
@required
- (void)returnedNewEndTime:(NSDictionary*)endTimeDictionary;
@end

@interface timerAction : NSObject {

	id<timerActionDelegate> delegate;

}

@property (nonatomic,assign) id<timerActionDelegate> delegate;

- (id)init;

-(void) scheduleNotificationForDate:(NSDate*)actionDate chosenURL:(NSString*)chosenURL alertTitle:(NSString*)alertTitle; 
-(void)deleteScheduledNotification:(NSString*)alertString;


@end