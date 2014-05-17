//
//  NHSCMapLocationViewController.h
//  Boy Scouts
//
//  Created by Troy Ling on 5/16/14.
//  Copyright (c) 2014 Daniel Webster Council Boy Scouts of America. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@interface NHSCMapLocationViewController : UIViewController <MKMapViewDelegate> {
    
    MKCoordinateRegion region;
    NSArray *places;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;

@property (nonatomic) MKCoordinateRegion region;
@property (nonatomic, strong) NSArray *places;
@property (nonatomic, strong) MKUserLocation *currentLocation;

- (IBAction)refreshButtonClicked:(id)sender;
- (IBAction)checkButtonClicked:(id)sender;
- (IBAction)noPopcornButtonClicked:(id)sender;

@end
