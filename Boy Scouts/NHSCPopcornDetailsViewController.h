//
//  NHSCPopcornDetailsViewController.h
//  Boy Scouts
//
//  Created by Troy Ling on 5/18/14.
//  Copyright (c) 2014 Daniel Webster Council Boy Scouts of America. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NHSCPlaceAnnotation.h"
#import "NHSCPopcornMapLocationViewController.h"

@interface NHSCPopcornDetailsViewController : UIViewController

@property (weak, nonatomic) NHSCPlaceAnnotation *annotation;
@property (weak) NHSCPopcornMapLocationViewController *parent;

@property (weak, nonatomic) IBOutlet UITextView *addressText;
@property (weak, nonatomic) IBOutlet UITextView *dateText;
@property (weak, nonatomic) IBOutlet UITextView *saleText;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) NSString *note;

- (IBAction)untrackLocation:(id)sender;
@end
