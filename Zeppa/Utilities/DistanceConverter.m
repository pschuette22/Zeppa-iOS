//
//  DistanceConverter.m
//  DistanceUtility
//
//  Created by Peter Schuette on 2/26/16.
//  Copyright © 2016 Peter Schuette. All rights reserved.
//

#import "DistanceConverter.h"
#import <math.h>

#define EARTH_RADIUS 6371 // approx radius of earth in kilometers
#define METERS_PER_MILE 1609.34
#define METERS_PER_KILOMETER 1000
#define FEET_PER_METER 3.28084

@implementation DistanceConverter


+(NSArray<CLLocation *>*) getAreaPoints:(double) distance inUnits:(DUUnitType) unitType from: (CLLocation*) location {
    
    // Result points to be returned
    NSMutableArray<CLLocation *> *points = [NSMutableArray<CLLocation *> array];
    
    
    /*
     * Convert provided distance in defined unit to kilometers
     */
    double distanceKM = 0;
    if(unitType == DUUnitKilometers) {
        distanceKM = distance;
    } else if (unitType == DUUnitMeters) {
        distanceKM = distance*METERS_PER_KILOMETER;
    } else if (unitType == DUUnitMiles) {
        distanceKM = (distance*METERS_PER_MILE)/METERS_PER_KILOMETER;
    } else if (unitType == DUUnitFeet) {
        distanceKM = (distance*FEET_PER_METER)/METERS_PER_KILOMETER;
    } else {
        // throw exception?
        return nil;
    }
    
    
    
    // Needed points that will be reused
    double lat = location.coordinate.latitude;
    double lon = location.coordinate.longitude;
    double distNorm = distanceKM/EARTH_RADIUS;
    
    /*
     * Calc location in the top left corner
     * This will be the first item in the result array
     */
    // (rad)ians pointing to (t)op (l)eft corner of result area
    double rad_tl = 3*M_PI/2; // 3 pi over 2
    // (lat)itude of (t)op (l)eft corner of result area
    double lat_tl = asin(sin(lat)*cos(distNorm)+cos(lat)*sin(distNorm)*cos(rad_tl));
    // (lon)gitude of (t)op (l)eft corner of result area
    double lon_tl = lon + atan2(sin(rad_tl)*sin(distNorm)*cos(lat), cos(distNorm)-sin(lat)*sin(lat_tl));
    
    // Resulting location
    CLLocation* location_tl = [[CLLocation alloc] initWithLatitude:lat_tl longitude:lon_tl];
    [points addObject:location_tl];
    
    /*
     * Calc location in the bottom right corner
     * This will be the second item in the result array
     */
    // (rad)ians pointing to (t)op (l)eft corner of result area
    double rad_br = -1*M_PI/2; // - PI over 2
    // (lat)itude of (t)op (l)eft corner of result area
    double lat_br = asin(sin(lat)*cos(distNorm)+cos(lat)*sin(distNorm)*cos(rad_br));
    // (lon)gitude of (t)op (l)eft corner of result area
    double lon_br = lon + atan2(sin(rad_br)*sin(distNorm)*cos(lat), cos(distNorm)-sin(lat)*sin(lat_br));
    
    // Resulting location
    CLLocation* location_br = [[CLLocation alloc] initWithLatitude:lat_br longitude:lon_br];
    [points addObject:location_br];
    
    
    return [NSArray arrayWithObject:points];
}


@end
