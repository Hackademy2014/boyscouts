//
//  NHSCDonationDetailsViewController.h
//  Boy Scouts
//
//  Created by Troy Ling on 5/17/14.
//  Copyright (c) 2014 Daniel Webster Council Boy Scouts of America. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NHSCPlaceAnnotation.h"
#import "NHSCDonationMapLocationViewController.h"

@interface NHSCDonationDetailsViewController : UIViewController

@property (weak, nonatomic) NHSCPlaceAnnotation *annotation;
@property (weak) NHSCDonationMapLocationViewController *parent;

@property (weak, nonatomic) IBOutlet UITextView *addressText;
@property (weak, nonatomic) IBOutlet UITextView *dateText;

- (IBAction)untrackLocation:(id)sender;

@end
