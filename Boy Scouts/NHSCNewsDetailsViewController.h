//
//  NHSCNewsDetailsViewController.h
//  Boy Scouts
//
//  Created by Hackademy on 5/17/14.
//  Copyright (c) 2014 Daniel Webster Council Boy Scouts of America. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NHSCNewsDetailsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (copy, nonatomic) NSString *url;
@end
