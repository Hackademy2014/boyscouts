//
//  NHSCPlaceAnnotation.h
//  Boy Scouts
//
//  Created by Troy Ling on 5/16/14.
//  Copyright (c) 2014 Daniel Webster Council Boy Scouts of America. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface NHSCPlaceAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *subTitle;
@property (nonatomic, retain) NSURL *url;

@end
