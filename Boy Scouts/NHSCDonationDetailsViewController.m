//
//  NHSCDonationDetailsViewController.m
//  Boy Scouts
//
//  Created by Troy Ling on 5/17/14.
//  Copyright (c) 2014 Daniel Webster Council Boy Scouts of America. All rights reserved.
//

#import "NHSCDonationDetailsViewController.h"
#import  <QuartzCore/QuartzCore.h>

@interface NHSCDonationDetailsViewController ()

@end

@implementation NHSCDonationDetailsViewController

@synthesize annotation;
@synthesize addressText;
@synthesize dateText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadAnnotation];
    
}

-(void) loadAnnotation {
    // address
    //To make the border look very close to a UITextField
    [addressText.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [addressText.layer setBorderWidth:2.0];
    
    //The rounded corner part, where you specify your view's corner radius:
    addressText.layer.cornerRadius = 5;
    addressText.clipsToBounds = YES;
    
    addressText.text = annotation.title;
    
    
#warning adds the date to pick up here
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
