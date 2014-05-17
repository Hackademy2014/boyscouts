//
//  NHSCMapLocationViewController.m
//  Boy Scouts
//
//  Created by Troy Ling on 5/16/14.
//  Copyright (c) 2014 Daniel Webster Council Boy Scouts of America. All rights reserved.
//

#import "NHSCMapLocationViewController.h"

@interface NHSCMapLocationViewController ()

@end

@implementation NHSCMapLocationViewController

@synthesize refreshButton;
@synthesize region;
@synthesize places;
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
    
    
    [_mapView setDelegate:self];
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

- (IBAction)refreshButtonClicked:(id)sender {
    // implement this later
}


/*
 * Stores user's location and reaction to the database
 */
- (IBAction)checkButtonClicked:(id)sender {
    // latitude and longtitude
    NSNumber *latitude = [NSNumber numberWithDouble: currentLocation.location.coordinate.latitude];
    NSNumber *longtitude = [NSNumber numberWithDouble: currentLocation.location.coordinate.longitude];
    
    if (latitude == 0 && longtitude == 0) {
        // error
        return;
    }
    
    // location should be saved into the database
    NSLog(@"%@", latitude);
    NSLog(@"%@", longtitude);
    
    // get the formatted address from Google
    NSString *address = [self getAddressFromLatLon:currentLocation.location.coordinate.latitude withLongitude:currentLocation.location.coordinate.longitude];
    
    // query to see if the location has been stored
    PFQuery *query = [PFQuery queryWithClassName:@"PopcornVisits"];
    [query whereKey:@"latitude" equalTo:latitude];
    [query whereKey:@"longtitude" equalTo:longtitude];
    
    // fire the request to the our back end
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            if (objects.count == 0) {
                // no previous entry is in the database.
                // save data to database
                PFObject *visit = [PFObject objectWithClassName:@"PopcornVisits"];
                visit[@"latitude"] = latitude;
                visit[@"longitude"] = longtitude;
                visit[@"reaction"] = @YES;
                visit[@"address"] = address;
                [visit saveInBackground];
            } else {
                // do nothing
            }
            // Do something with the found objects
            //            for (PFObject *object in objects) {
            //                NSLog(@"%@", object.objectId);
            //            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

/*
 * get the address from location
 */
-(NSString *)getAddressFromLatLon:(double)pdblLatitude withLongitude:(double)pdblLongitude
{
    //key arg: &key=AIzaSyBKYuW9J2M9tAh2ZdxrYkz2N9UY-mSe4gI
    //    NSData *dataUrl = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    //    NSArray *readJsonArray = [NSJSONSerialization JSONObjectWithData:dataUrl options:0 error:0];
    //    NSDictionary *element1 = readJsonArray[0][0];
    //    NSString *address = element1[@"formatted_address"];
    //    NSLog(@"%@", address);
    //    return address;
    //    locationString = [locationString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    //    locationString = [locationString substringFromIndex:6];
    NSString *address;
    NSError* error;
    
    // retrieve the name for the location
    NSString *urlString = [NSString stringWithFormat: @"https://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true", pdblLatitude, pdblLongitude];
    NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSASCIIStringEncoding error:&error];

    // parse jason object
    NSData *data = [locationString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error){
        NSLog(@"Some error %ld", error.code);
    } else {
        address = [[json objectForKey:@"results"] valueForKey:@"formatted_address"][0];
    }

    return address;
}

- (IBAction)noPopcornButtonClicked:(id)sender {
    // location should be saved into the database
    NSLog(@"Check button clicked");
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
    
    region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 10000, 10000);
    [mapView setRegion:region animated:NO];
    
    // remove us as delegate so we don't re-center map each time user moves
    //mapView.delegate = nil;
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
