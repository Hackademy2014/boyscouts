//
//  NHSCLeftMenuTableViewController.m
//  Boy Scouts
//
//  Created by Troy Ling on 5/16/14.
//  Copyright (c) 2014 Daniel Webster Council Boy Scouts of America. All rights reserved.
//

#import "NHSCLeftMenuTableViewController.h"

@interface NHSCLeftMenuTableViewController ()

@end

@implementation NHSCLeftMenuTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && ![UIApplication sharedApplication].isStatusBarHidden)
    {
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    }
    
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        // The device is an iPhone or iPod touch.
        [self setFixedStatusBar];
    }
}

- (void)setFixedStatusBar
{
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAX(self.view.frame.size.width,self.view.frame.size.height), 20)];
    statusBarView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:statusBarView];
}

@end
