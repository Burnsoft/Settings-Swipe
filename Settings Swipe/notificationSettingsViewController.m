//
//  notificationSettingsViewController.m
//  AppSwipe
//
//  Created by Nicholas Burns on 20/01/2012.
//  Copyright (c) 2012 Burnsoft. All rights reserved.
//

#import "notificationSettingsViewController.h"

@implementation notificationSettingsViewController
@synthesize prefsArray,chosenArray,saveButton,addButton,cancelButton,editOrderButton,appswipeButton;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    prefsArray = [[NSMutableArray alloc] init];
    chosenArray = [[NSMutableArray alloc] init];
    [chosenArray addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"userChosenItems"]];

    NSString* plistPath = [[NSBundle mainBundle] pathForResource:NSLocalizedString(@"settingsURLs",@"") ofType:@"plist"];
    NSArray *plistTempArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
    [prefsArray addObjectsFromArray:plistTempArray];
    [plistTempArray release];
        
    self.title = NSLocalizedString(@"Quick Launch", @"Quick Launch");
    
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    self.addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
                                                                   target:self 
                                                                   action:@selector(plusButtonHit)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
                                                                    target:self 
                                                                    action:@selector(saveNotifications)];
    
    [self.tableView setEditing:NO animated:YES];    
    self.tableView.separatorColor = [UIColor blackColor];
    self.tableView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                                                      target:self 
                                                                      action:@selector(cancelButtonHit)];
    
    self.editOrderButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit 
                                                                         target:self 
                                                                         action:@selector(userWantsToAmendOrder)];

    self.appswipeButton = [[UIBarButtonItem alloc] initWithTitle:@"App Swipe" 
                                                           style:UIBarButtonItemStylePlain 
                                                          target:self 
                                                          action:@selector(fireUpTheAppStore)];
    
    self.navigationItem.leftBarButtonItem = appswipeButton;

}



-(void)cancelButtonHit;
{
    [self.tableView setEditing:NO animated:YES];
    self.navigationItem.leftBarButtonItem = nil;    
    self.navigationItem.rightBarButtonItem = addButton;
    [self.tableView reloadData];
}

-(void)plusButtonHit;
{
    [self enterEditMode];    
}

-(void)enterEditMode;
{    
    [self.tableView setEditing:YES animated:YES];
    [self.tableView reloadData];
    self.navigationItem.leftBarButtonItem = saveButton;
    self.navigationItem.rightBarButtonItem = cancelButton;
}


-(void)saveNotifications;
{
    [chosenArray removeAllObjects];
    
    if([self.tableView indexPathsForSelectedRows].count>0){
        
        [chosenArray removeAllObjects];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        timerAction *ta = [[timerAction alloc] init];
        NSDate *dateToShow = [NSDate distantPast];
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        

        NSArray* selectedRows = [[[self.tableView indexPathsForSelectedRows] reverseObjectEnumerator] allObjects];
   
        for (int i=0;i<prefsArray.count;i++) {
            
            for (int j=0;j<selectedRows.count;j++){
                NSIndexPath *ap = [selectedRows objectAtIndex:j];
                if (ap.row == i) {
                    NSDictionary *fireDic = [prefsArray objectAtIndex:ap.row]; 
                    [tempArray addObject:fireDic];
                }
            }
        }
        
        [chosenArray addObjectsFromArray:tempArray];
        
        NSArray *reversed = [[tempArray reverseObjectEnumerator] allObjects];
        
        for (NSDictionary *dd in reversed){
            [ta scheduleNotificationForDate:dateToShow chosenURL:[dd objectForKey:@"chosenURL"] alertTitle:[dd objectForKey:@"Action"]];
        }
        
        [tempArray release];
        [ta release];
        
        
    }
    [[NSUserDefaults standardUserDefaults] setObject:chosenArray forKey:@"userChosenItems"];
    
    [self.tableView setEditing:NO animated:YES];
    
    self.navigationItem.leftBarButtonItem = appswipeButton;
    self.navigationItem.rightBarButtonItem = addButton;

    
    [self.tableView reloadData];
    
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSIndexPath *selection = [self.tableView indexPathForSelectedRow];
    
	if (selection)
		[self.tableView deselectRowAtIndexPath:selection animated:YES];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.tableView.editing)
    {
        return prefsArray.count;
    }
    else
    {
        return chosenArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if(self.tableView.editing){
        NSDictionary *iprefDic = [prefsArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [iprefDic objectForKey:@"Action"];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.imageView.image = [UIImage imageNamed:[iprefDic objectForKey:@"Icon"]];
    }else
    {
        NSDictionary *iprefDic = [chosenArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [iprefDic objectForKey:@"Action"];   
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.imageView.image = [UIImage imageNamed:[iprefDic objectForKey:@"Icon"]];
    }    
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16];
    
    return cell;
}

-(void) tableView: (UITableView *) tableView moveRowAtIndexPath: (NSIndexPath *) oldPath toIndexPath:(NSIndexPath *) newPath
{
    NSDictionary *iprefDic = [[prefsArray objectAtIndex:oldPath.row] retain];
    [prefsArray removeObjectAtIndex:[oldPath row]];
    [prefsArray insertObject:iprefDic atIndex:[newPath row]];
    [iprefDic release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 40;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!self.tableView.editing){

        NSDictionary *iprefDic = [chosenArray objectAtIndex:indexPath.row];
        NSString *cURL = [iprefDic objectForKey:@"chosenURL"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:cURL]];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }
}

-(void)fireUpTheAppStore;
{

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/app-swipe/id482494990?mt=8&partnerId=30&siteID=BcMBY/pRbWY"]];

}

@end
