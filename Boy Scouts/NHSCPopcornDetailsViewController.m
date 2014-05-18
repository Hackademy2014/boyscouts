//
//  NHSCPopcornDetailsViewController.m
//  Boy Scouts
//
//  Created by Troy Ling on 5/18/14.
//  Copyright (c) 2014 Daniel Webster Council Boy Scouts of America. All rights reserved.
//

#import "NHSCPopcornDetailsViewController.h"
#import "NHSCPopcornNoteViewController.h"

@interface NHSCPopcornDetailsViewController ()

@end

@implementation NHSCPopcornDetailsViewController

@synthesize parent;
@synthesize annotation;
@synthesize addressText;
@synthesize dateText;
@synthesize noteLabel;
@synthesize saleText;

PFObject *annotationObj;
NSString *address;
NSDate *date;
NSString *note;

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
                    note = visit[@"note"];
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
    
    if ([annotationObj[@"reaction"]  isEqual: @YES]) {
        // set text color green
        addressText.textColor = [UIColor colorWithRed:0.33 green:0.85 blue:0.11 alpha:1];
        dateText.textColor = [UIColor colorWithRed:0.33 green:0.85 blue:0.11 alpha:1];
        saleText.textColor = [UIColor colorWithRed:0.33 green:0.85 blue:0.11 alpha:1];
        
    } else {
        // set text color red
        addressText.textColor = [UIColor colorWithRed:1.00 green:0.20 blue:0.22 alpha:1];
        dateText.textColor = [UIColor colorWithRed:1.00 green:0.20 blue:0.22 alpha:1];
        saleText.textColor = [UIColor colorWithRed:1.00 green:0.20 blue:0.22 alpha:1];
    }
    
    if (note) {
        // sale text
        [saleText.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
        [saleText.layer setBorderWidth:2.0];
        
        //The rounded corner part, where you specify your view's corner radius:
        saleText.layer.cornerRadius = 5;
        saleText.clipsToBounds = YES;
        
        saleText.text = note;
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"popcornNote"]) {
        // set the address for query
        NHSCPopcornNoteViewController *note = [segue destinationViewController];
        note.annotationObj = annotationObj;
        note.parent = self;
    }
}


@end
