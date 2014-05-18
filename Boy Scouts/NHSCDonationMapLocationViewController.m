//
//  NHSCDonationMapLocationViewController.m
//  Boy Scouts
//
//  Created by Troy Ling on 5/17/14.
//  Copyright (c) 2014 Daniel Webster Council Boy Scouts of America. All rights reserved.
//

#import "NHSCDonationMapLocationViewController.h"
#import "NHSCPlaceAnnotation.h"
#import "NHSCAddressHelper.h"

@interface NHSCDonationMapLocationViewController ()

@end

@implementation NHSCDonationMapLocationViewController

@synthesize region;
@synthesize currentLocation;

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
    
    // set itself to be the delegate of the map view
    self.mapView.delegate = self;
    
    // sets the annotaions
    [self displayAnnotations];
    
    // initialize current location if necessary
    if (!currentLocation) {
        currentLocation = [self.mapView userLocation];
        region = MKCoordinateRegionMakeWithDistance(currentLocation.location.coordinate, 500, 500);
        [self.mapView setRegion:region animated:NO];
    }
}

/*
 * Finds the nearby locations that have record for the popcorn
 */
- (void)displayAnnotations {
    
    // remove all annocations
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    // Find locations around from backend
    PFQuery *query = [PFQuery queryWithClassName:@"FoodDonationVisits"];
    
    // locations should be within a range
    
    query.limit = 10;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *visits, NSError *error) {
        if (!error) {
            // populate the visits to the view
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)visits.count);
            // Do something with the found objects
            for (PFObject *visit in visits) {
                double latitude = [visit[@"latitude"] doubleValue];
                double longitude = [visit[@"longitude"] doubleValue];
                NSString *title = visit[@"address"];
                
                // creates annotation
                CLLocationCoordinate2D visitCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
                
                NHSCPlaceAnnotation *pin = [[NHSCPlaceAnnotation alloc] init];
                pin.coordinate = visitCoordinate;
                pin.title = title;
                
                // adds annotation to the map
                [self.mapView addAnnotation:pin];
            }
        } else {
            // error
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}

// center the user's current location in the map view
- (IBAction)locateButtonClicked:(id)sender {
    region = MKCoordinateRegionMakeWithDistance(currentLocation.location.coordinate, 500, 500);
    [self.mapView setRegion:region animated:YES];
}

/*
 * stores the food pickup location for future pickup
 */
- (IBAction)pickButtonClicked:(id)sender {
    // check if location is null;
    if (currentLocation == nil) {
        // handle this properly
        return;
    }
    
    // latitude and longtitude
    NSNumber *latitude = [NSNumber numberWithDouble: currentLocation.location.coordinate.latitude];
    NSNumber *longtitude = [NSNumber numberWithDouble: currentLocation.location.coordinate.longitude];
    
    // get the formatted address from Google
    NSString *address = [NHSCAddressHelper getAddressFromLatLon:currentLocation.location.coordinate.latitude withLongitude:currentLocation.location.coordinate.longitude];
    
    // query to see if the location has been stored
    PFQuery *query = [PFQuery queryWithClassName:@"FoodDonationVisits"];
    [query whereKey:@"address" equalTo:address];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *visits, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)visits.count);
            if (visits.count == 0) {
                // no previous entry is in the database.
                // save new data to database
                PFObject *visit = [PFObject objectWithClassName:@"FoodDonationVisits"];
                visit[@"latitude"] = latitude;
                visit[@"longitude"] = longtitude;
                visit[@"address"] = address;
                [visit saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if(succeeded) {
                        // creates annotation and updates the view
                        CLLocationCoordinate2D visitCoordinate = CLLocationCoordinate2DMake(currentLocation.location.coordinate.latitude, currentLocation.location.coordinate.longitude);
                        
                        NHSCPlaceAnnotation *pin = [[NHSCPlaceAnnotation alloc] init];
                        pin.coordinate = visitCoordinate;
                        pin.title = address;
                        
                        // adds annotation to the map
                        [self.mapView addAnnotation:pin];
                    }
                }];
            } else {
                // do nothing
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MapView Delegate Methods

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    // store the user location
    currentLocation = userLocation;
    
    region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 500, 500);
    [mapView setRegion:region animated:NO];
    
    // remove us as delegate so we don't re-center map each time user moves
    //mapView.delegate = nil;
}

/*
 * customize annotation
 */
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(NHSCPlaceAnnotation*)annotation {
    if([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString *identifier = @"myAnnotation";
    MKPinAnnotationView * annotationView = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!annotationView)
    {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.animatesDrop = NO;
        annotationView.canShowCallout = YES;
    }else {
        annotationView.annotation = annotation;
    }
    
    // set the color of the pin
    annotationView.pinColor = MKPinAnnotationColorPurple;
    
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return annotationView;
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
