//
//  AppDelegate.m
//  AppSwipe
//
//  Created by Nicholas Burns on 20/01/2012.
//  Copyright (c) 2012 Burnsoft Ltd. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate

@synthesize window = _window;
@synthesize userActionCount,localCount;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    localCount = 0; // suppress firing notifications when first set
    userActionCount = 0;
    
    [[UIApplication sharedApplication]registerForRemoteNotificationTypes: UIRemoteNotificationTypeAlert]; 

    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    notificationSettingsViewController *rootViewController = [[notificationSettingsViewController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    
    self.window.rootViewController = navController;
    [rootViewController release];
    [self.window makeKeyAndVisible];
    
    
    UILocalNotification *localNotif = [launchOptions
                                       objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    	
    if (localNotif) {
        NSString *cURL = [localNotif.userInfo objectForKey:@"chosenURL"];
        [self fireURLChosenByUser:cURL];
    }
    
    return YES;
}



-(void)fireURLChosenByUser:(NSString*)cURL;
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:cURL]];
	
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if(userActionCount > 0){        
        userActionCount --; // suppress firing when being set
    }
    else {        
        if (notification) {
            NSString *cURL = [notification.userInfo objectForKey:@"chosenURL"];
            [self fireURLChosenByUser:cURL];
        }
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
