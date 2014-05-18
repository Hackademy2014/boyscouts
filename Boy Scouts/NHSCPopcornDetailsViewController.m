//
//  NHSCPopcornDetailsViewController.m
//  Boy Scouts
//
//  Created by Troy Ling on 5/18/14.
//  Copyright (c) 2014 Daniel Webster Council Boy Scouts of America. All rights reserved.
//

#import "NHSCPopcornDetailsViewController.h"

@interface NHSCPopcornDetailsViewController ()

@end

@implementation NHSCPopcornDetailsViewController

@synthesize parent;
@synthesize annotation;
@synthesize addressText;
@synthesize dateText;
@synthesize saleText;

PFObject *annotationObj;
NSString *address;
NSDate *date;

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// find the annotation from database
-(void)findDonnationFromDB {
    PFQuery *query = [PFQuery queryWithClassName:@"PopcornVisits"];
    [query whereKey:@"address" equalTo:annotation.title];
    [query findObjectsInBackgroundWithBlock:^(NSArray *visits, NSError *error) {
        if (!error) {
            // The find succeeded.
            if (visits.count == 1) {
                // Do something with the found objects
                for (PFObject *visit in visits) {
                    annotationObj = visit;
                    address = visit[@"address"];
                    date = visit.createdAt;
        
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
    
    // date of the sale
    [dateText.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [dateText.layer setBorderWidth:2.0];
    
    //The rounded corner part, where you specify your view's corner radius:
    dateText.layer.cornerRadius = 5;
    dateText.clipsToBounds = YES;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE MMMM d, YYYY"];
    
    NSString *stringFromDate = [formatter stringFromDate:date];
    dateText.text = stringFromDate;
    
    
    // sale text
    [saleText.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [saleText.layer setBorderWidth:2.0];
    
    //The rounded corner part, where you specify your view's corner radius:
    saleText.layer.cornerRadius = 5;
    saleText.clipsToBounds = YES;
    
    if ([annotationObj[@"reaction"]  isEqual: @YES]) {
        saleText.text = @"Popcorn was previously sold to the resident.";
    } else {
        saleText.text = @"Resident did not like the popcorn.";
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
