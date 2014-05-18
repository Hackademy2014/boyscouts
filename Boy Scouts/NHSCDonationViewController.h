//
//  NHSCDonationViewController.h
//  Boy Scouts
//
//  Created by Troy Ling on 5/18/14.
//  Copyright (c) 2014 Daniel Webster Council Boy Scouts of America. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NHSCDonationDetailsViewController.h"

@interface NHSCDonationViewController : UIViewController

@property (weak, nonatomic) NHSCDonationDetailsViewController *parent;
@property (weak, nonatomic) PFObject *annotationObj;
@property (weak, nonatomic) IBOutlet UITextView *noteText;

- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)doneButtonClicked:(id)sender;

@end
