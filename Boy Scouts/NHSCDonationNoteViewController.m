//
//  NHSCDonationViewController.m
//  Boy Scouts
//
//  Created by Troy Ling on 5/18/14.
//  Copyright (c) 2014 Daniel Webster Council Boy Scouts of America. All rights reserved.
//

#import "NHSCDonationNoteViewController.h"

@interface NHSCDonationNoteViewController ()

@end

@implementation NHSCDonationNoteViewController

@synthesize annotationObj;
@synthesize parent;
@synthesize noteText;

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
    [self loadNote];
}

- (void)loadNote {
    note = annotationObj[@"note"];
    
    if(note) {
        noteText.text = note;
    }
    
    // change the style of the border
    [noteText.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [noteText.layer setBorderWidth:2.0];
    
    //The rounded corner part, where you specify your view's corner radius:
    noteText.layer.cornerRadius = 5;
    noteText.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cancelButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButtonClicked:(id)sender {
    // sent to server
    
    if (note != noteText.text) {
        // save the note
        annotationObj[@"note"] = noteText.text;
        [annotationObj saveInBackground];
        
        // update the parent view before going back
        parent.note = noteText.text;
        parent.noteLabel.text = @"Note";
        parent.noteText.text = noteText.text;
        
        [parent.noteText.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
        [parent.noteText.layer setBorderWidth:2.0];
        
        //The rounded corner part, where you specify your view's corner radius:
        parent.noteText.layer.cornerRadius = 5;
        parent.noteText.clipsToBounds = YES;
    }
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
