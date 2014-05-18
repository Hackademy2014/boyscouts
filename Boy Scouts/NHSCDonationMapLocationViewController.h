//
//  NHSCDonationMapLocationViewController.h
//  Boy Scouts
//
//  Created by Troy Ling on 5/17/14.
//  Copyright (c) 2014 Daniel Webster Council Boy Scouts of America. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@interface NHSCDonationMapLocationViewController : UIViewController <MKMapViewDelegate> {
    MKCoordinateRegion region;
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) MKCoordinateRegion region;
@property (nonatomic, strong) MKUserLocation *currentLocation;

- (IBAction)pickButtonClicked:(id)sender;
- (IBAction)locateButtonClicked:(id)sender;


@end
