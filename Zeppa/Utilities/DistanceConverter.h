//
//  DistanceConverter.h
//  DistanceUtility
//
//  Created by Peter Schuette on 2/26/16.
//  Copyright © 2016 Peter Schuette. All rights reserved.
//
// Based on http://www.movable-type.co.uk/scripts/latlong.html


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface DistanceConverter : NSObject

enum DUUnitType : NSUInteger {
    DUUnitMeters = 0,
    DUUnitKilometers=1,
    DUUnitMiles=2,
    DUUnitFeet=3
};
typedef NSUInteger DUUnitType;

/*
 * Gets an array of 2 locations which represent the top left and bottom right of an area which are the defined distance away from the provided location
 */
+(NSArray<CLLocation *>*) getAreaPoints:(double) distance inUnits:(DUUnitType) unitType from: (CLLocation*) location;


@end
