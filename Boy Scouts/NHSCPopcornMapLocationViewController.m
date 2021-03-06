//
//  NHSCMapLocationViewController.m
//  Boy Scouts
//
//  Created by Troy Ling on 5/16/14.
//  Copyright (c) 2014 Daniel Webster Council Boy Scouts of America. All rights reserved.
//

#import "NHSCPopcornMapLocationViewController.h"
#import "NHSCPlaceAnnotation.h"
#import "NHSCAddressHelper.h"
#import "NHSCPopcornDetailsViewController.h"

@interface NHSCPopcornMapLocationViewController ()

@end

@implementation NHSCPopcornMapLocationViewController

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
    PFQuery *query = [PFQuery queryWithClassName:@"PopcornVisits"];
    
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
                BOOL reaction = [visit[@"reaction"] boolValue];
                
                // creates annotation
                CLLocationCoordinate2D visitCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
                
                NHSCPlaceAnnotation *pin = [[NHSCPlaceAnnotation alloc] init];
                pin.coordinate = visitCoordinate;
                pin.title = title;
                pin.reaction = reaction;
                
                // adds annotation to the map
                [self.mapView addAnnotation:pin];
            }
        } else {
            // error
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    // check to see if Location Services is enabled, there are two state possibilities:
    // 1) disabled for entire device, 2) disabled just for this app
    //
    NSString *causeStr = nil;
    
    // check whether location services are enabled on the device
    if ([CLLocationManager locationServicesEnabled] == NO)
    {
        causeStr = @"device";
    }
    // check the application’s explicit authorization status:
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        causeStr = @"app";
    }
    else
    {
        // All is okay
    }
    
    if (causeStr != nil)
    {
        NSString *alertMessage = [NSString stringWithFormat:@"You currently have location services disabled for this %@. Please refer to \"Settings\" app to turn on Location Services.", causeStr];
        
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled"
                                                                        message:alertMessage
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
        [servicesDisabledAlert show];
    }
}

// center the user's current location in the map view
- (IBAction)locateButtonClicked:(id)sender {
    region = MKCoordinateRegionMakeWithDistance(currentLocation.location.coordinate, 500, 500);
    [self.mapView setRegion:region animated:YES];
}

/*
 * Stores user's location and reaction to the database
 */
- (IBAction)checkButtonClicked:(id)sender {
    
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
    PFQuery *query = [PFQuery queryWithClassName:@"PopcornVisits"];
    //    [query whereKey:@"latitude" equalTo:latitude];
    //    [query whereKey:@"longtitude" equalTo:longtitude];
    [query whereKey:@"address" equalTo:address];
    
    // fire the request to the our back end
    [query findObjectsInBackgroundWithBlock:^(NSArray *visits, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)visits.count);
            if (visits.count == 0) {
                // no previous entry is in the database.
                // save new data to database
                PFObject *visit = [PFObject objectWithClassName:@"PopcornVisits"];
                visit[@"latitude"] = latitude;
                visit[@"longitude"] = longtitude;
                visit[@"reaction"] = @YES;
                visit[@"address"] = address;
                [visit saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if(succeeded) {
                        [self displayAnnotations];
                    }
                }];
                
                // add annotation to the map
                //                [self displayAnnotations];
            } else if (visits.count == 1) {
                // update the reactino if necessary
                for (PFObject *visit in visits) {
                    if ([visit[@"reaction"]  isEqual: @NO]) {
                        visit[@"reaction"] = @YES;
                        [visit saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if(succeeded) {
                                [self displayAnnotations];
                            }
                        }];
                    }
                }
                
                // update the annotation to the map
                
            } else {
                // multiple instances, should do nothing
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (IBAction)noPopcornButtonClicked:(id)sender {
    
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
    PFQuery *query = [PFQuery queryWithClassName:@"PopcornVisits"];
    //    [query whereKey:@"latitude" equalTo:latitude];
    //    [query whereKey:@"longtitude" equalTo:longtitude];
    [query whereKey:@"address" equalTo:address];
    
    // fire the request to the our back end
    [query findObjectsInBackgroundWithBlock:^(NSArray *visits, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)visits.count);
            if (visits.count == 0) {
                // no previous entry is in the database.
                // save data to database
                PFObject *visit = [PFObject objectWithClassName:@"PopcornVisits"];
                visit[@"latitude"] = latitude;
                visit[@"longitude"] = longtitude;
                visit[@"reaction"] = @NO;
                visit[@"address"] = address;
                //                [visit saveInBackground];
                
                [visit saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if(succeeded) {
                        [self displayAnnotations];
                    }
                }];
                
                // add annotations
                
            } else if (visits.count == 1) {
                // update the reactino if necessary
                for (PFObject *visit in visits) {
                    if ([visit[@"reaction"]  isEqual: @YES]) {
                        visit[@"reaction"] = @NO;
                        [visit saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if(succeeded) {
                                [self displayAnnotations];
                            }
                        }];
                    }
                }
            } else {
                // multiple instances, should do nothing
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
    if (annotation.reaction == YES) {
        annotationView.pinColor = MKPinAnnotationColorGreen;
    } else {
        annotationView.pinColor = MKPinAnnotationColorRed;
    }
    
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return annotationView;
}

/*
 * Open the detail view for the selected annotation
 */
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    [self performSegueWithIdentifier:@"showPopcornDetails" sender:view];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"showPopcornDetails"]) {
        
        // get the associated annotation
        MKAnnotationView *view = (MKAnnotationView *)sender;
        NHSCPlaceAnnotation *pin = view.annotation;
        
        // Get the new view controller using [segue destinationViewController].
        NHSCPopcornDetailsViewController *dest = [segue destinationViewController];
        
        // Pass the selected object to the new view controller.
        dest.annotation = pin;
        dest.parent = self;
        
    }
}

@end
