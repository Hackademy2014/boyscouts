//
//  NHSCAddressHelper.h
//  Boy Scouts
//
//  Created by Troy Ling on 5/17/14.
//  Copyright (c) 2014 Daniel Webster Council Boy Scouts of America. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NHSCAddressHelper : NSObject

+(NSString *)getAddressFromLatLon:(double)pdblLatitude withLongitude:(double)pdblLongitude;

@end
