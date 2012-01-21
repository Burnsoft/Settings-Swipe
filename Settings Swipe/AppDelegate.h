//
//  AppDelegate.h
//  AppSwipe
//
//  Created by Nicholas Burns on 20/01/2012.
//  Copyright (c) 2012 Burnsoft Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "notificationSettingsViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSInteger userActionCount;
    NSInteger localCount;
    
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) NSInteger userActionCount;
@property (nonatomic) NSInteger localCount;

-(void)fireURLChosenByUser:(NSString*)cURL;

@end
