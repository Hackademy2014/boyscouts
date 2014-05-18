//
//  NHSCDonationDetailsViewController.m
//  Boy Scouts
//
//  Created by Troy Ling on 5/17/14.
//  Copyright (c) 2014 Daniel Webster Council Boy Scouts of America. All rights reserved.
//

#import "NHSCDonationDetailsViewController.h"
#import "NHSCDonationNoteViewController.h"
#import  <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>

@interface NHSCDonationDetailsViewController ()

@end

@implementation NHSCDonationDetailsViewController

@synthesize parent;
@synthesize annotation;
@synthesize addressText;
@synthesize dateText;
@synthesize noteLabel;
@synthesize noteText;
@synthesize note;

PFObject *annotationObj;
NSString *address;
NSDate *dateToPickup;

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
    [self findDonnationFromDB];
}

// find the annotation from database
-(void)findDonnationFromDB {
    PFQuery *query = [PFQuery queryWithClassName:@"FoodDonationVisits"];
    [query whereKey:@"address" equalTo:annotation.title];
    [query findObjectsInBackgroundWithBlock:^(NSArray *visits, NSError *error) {
        if (!error) {
            // The find succeeded.
            if (visits.count == 1) {
                // Do something with the found objects
                for (PFObject *visit in visits) {
                    annotationObj = visit;
                    address = visit[@"address"];
                    note = visit[@"note"];
                    dateToPickup = visit.createdAt;
                    
                    // adds a week to the created date
                    NSCalendar *calendar=[NSCalendar currentCalendar];
                    NSDateComponents *components = [[NSDateComponents alloc]init];
                    components.day = 7;
                    dateToPickup =[calendar dateByAddingComponents:components toDate:dateToPickup options:0];
                    
                    // set up the view
                    [self loadAnnotation];
                }
                
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(void)loadAnnotation {
    
    // address text view
    //To make the border look very close to a UITextField
    [addressText.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [addressText.layer setBorderWidth:2.0];
    
    //The rounded corner part, where you specify your view's corner radius:
    addressText.layer.cornerRadius = 5;
    addressText.clipsToBounds = YES;
    
    addressText.text = address;
    
    // date to pick up
    [dateText.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [dateText.layer setBorderWidth:2.0];
    
    //The rounded corner part, where you specify your view's corner radius:
    dateText.layer.cornerRadius = 5;
    dateText.clipsToBounds = YES;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE MMMM d, YYYY"];
    
    NSString *stringFromDate = [formatter stringFromDate:dateToPickup];
    dateText.text = stringFromDate;
    
    if (note) {
        // sale text
        [noteText.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
        [noteText.layer setBorderWidth:2.0];
        
        //The rounded corner part, where you specify your view's corner radius:
        noteText.layer.cornerRadius = 5;
        noteText.clipsToBounds = YES;
        
        noteText.text = note;
    } else {
        // note is not available
        noteLabel.text = @"";
    }
}


/*
 * untrack this location by removing it from the database
 */
- (IBAction)untrackLocation:(id)sender {
    [annotationObj deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // go back to the map view
            [parent displayAnnotations];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

/*
 * this function is executed when user clicks the back button
 */
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController || self.isBeingDismissed) {
        NSLog(@"%@", self.parentViewController);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"donationNote"]) {
        // set the address for query
        NHSCDonationNoteViewController *note = [segue destinationViewController];
        note.annotationObj = annotationObj;
        note.parent = self;
    }
}

@end
