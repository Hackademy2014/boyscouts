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

@interface NHSCPopcornMapLocationViewController : UIViewController <MKMapViewDelegate> {
    MKCoordinateRegion region;
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic) MKCoordinateRegion region;
@property (nonatomic, strong) MKUserLocation *currentLocation;

- (IBAction)locateButtonClicked:(id)sender;
- (IBAction)checkButtonClicked:(id)sender;
- (IBAction)noPopcornButtonClicked:(id)sender;

@end
