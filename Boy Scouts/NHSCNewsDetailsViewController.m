//
//  NHSCNewsDetailsViewController.m
//  Boy Scouts
//
//  Created by Hackademy on 5/17/14.
//  Copyright (c) 2014 Daniel Webster Council Boy Scouts of America. All rights reserved.
//

#import "NHSCNewsDetailsViewController.h"

@interface NHSCNewsDetailsViewController ()
- (void)configureView;
@end

@implementation NHSCNewsDetailsViewController


#pragma mark - Managing the detail item

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *myURL = [NSURL URLWithString: [self.url stringByAddingPercentEscapesUsingEncoding:
                                          NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
    [self.webView loadRequest:request];
}

@end