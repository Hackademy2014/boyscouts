//
//  NHSCContactUsViewController.m
//  Boy Scouts
//
//  Created by Hackademy on 5/17/14.
//  Copyright (c) 2014 Daniel Webster Council Boy Scouts of America. All rights reserved.
//

#import "NHSCContactUsViewController.h"

@interface NHSCContactUsViewController ()

@end

@implementation NHSCContactUsViewController

#pragma mark - Generated Methods

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Contact Us Methods

/**
 *  Show the website in the Default Browser
 *  http://www.nhscouting.org
 */
- (IBAction)showWebsite
{
    //Open the default browser and load the website's url
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.nhscouting.org/"]];
}

- (IBAction)openFacebook {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com/nhscouting"]];
}

- (IBAction)openTwitter{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.twitter.com/DWCBSA"]];
}

- (IBAction)openYouTube{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.youtube.com/DWCBSA"]];
    
}

/**
 *  When clicked, the phone will start calling the phone number listed.
 */
- (IBAction)callPhone
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Call NH Boy Scouts?"
                                                     message:@"Would you like to call (603) 625-6431?"
                                                    delegate:self cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"Call", nil];
    
    alert.alertViewStyle = UIAlertViewStyleDefault;
    [alert show];
}


/**
 *  When clicked, the mail app will open with the to: field pre-filled with the email address below.
 */
- (IBAction)emailNonProfit
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://info@nhscouting.org"]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://16036256431"]];
    }
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

