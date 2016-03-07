//
//  ZPAMapsVC.m
//  Zeppa
//
//  Created by Peter Schuette on 2/25/16.
//  Copyright © 2016 Pete Schuette. All rights reserved.
//

#import "ZPAMapsVC.h"
#import "ZPAEventInfoBase.h"

@import GoogleMaps;

@implementation ZPAMapsVC {
    GMSMapView *mapView;
}

// When the view loads, let er rip
-(void) viewDidLoad {
    [super viewDidLoad];
    double lat = _eventDetails.zeppaEvent.latitude.doubleValue;
    double lon = _eventDetails.zeppaEvent.longitude.doubleValue;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat
                                                            longitude:lon
                                                                 zoom:15];
    mapView = [GMSMapView mapWithFrame:self.view.frame camera:camera];
    [mapView setUserInteractionEnabled:YES];
//    [mapView setMyLocationEnabled:YES];
    
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(lat, lon);
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    marker.map = mapView;
    [mapView setSelectedMarker:marker];
    
    self.view = mapView;
    
    // TODO: Add option to navigate
    
}


@end
