//
//  notificationSettingsViewController.h
//  AppSwipe
//
//  Created by Nicholas Burns on 20/01/2012.
//  Copyright (c) 2012 Burnsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "timerAction.h"

@interface notificationSettingsViewController : UITableViewController


{
    
    NSMutableArray *prefsArray;
    NSMutableArray *chosenArray;
    UIBarButtonItem *saveButton;
    UIBarButtonItem *addButton;
    UIBarButtonItem *cancelButton;
    UIBarButtonItem *editOrderButton;
    UIBarButtonItem *appswipeButton;

    
}

@property (strong, nonatomic) NSMutableArray *prefsArray;
@property (strong, nonatomic) NSMutableArray *chosenArray;
@property (nonatomic, strong) UIBarButtonItem *saveButton;
@property (nonatomic, strong) UIBarButtonItem *addButton;
@property (nonatomic, strong) UIBarButtonItem *cancelButton;
@property (nonatomic, strong) UIBarButtonItem *editOrderButton,*appswipeButton;

-(void)enterEditMode;


@end