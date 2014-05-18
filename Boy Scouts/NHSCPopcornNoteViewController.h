//
//  NHSCPopcornNoteViewController.h
//  Boy Scouts
//
//  Created by Troy Ling on 5/18/14.
//  Copyright (c) 2014 Daniel Webster Council Boy Scouts of America. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NHSCPopcornDetailsViewController.h"

@interface NHSCPopcornNoteViewController : UIViewController

@property (weak, nonatomic) NHSCPopcornDetailsViewController *parent;
@property (weak, nonatomic) NSString *address;
@property (weak, nonatomic) IBOutlet UITextView *noteText;

@end
