//
//  ZPAMapViewController.m
//  Zeppa
//
//  Created by Faran on 30/06/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPAMapViewController.h"
#import "MBProgressHUD.h"
#import <MapKit/MapKit.h>

#define METERS_PER_MILE 1609.344

@interface ZPAMapViewController ()

@end

@implementation ZPAMapViewController{
    
    MBProgressHUD * progress;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    _mapView.delegate = self;
    
    progress =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [progress show:YES];
    progress.labelText = @"Loading Location..";
    
    [self loadMapLocation];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    
    
}


-(void)loadMapLocation{
    
    __block CLLocationCoordinate2D maplocation;
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    __block CGFloat latitude;
    __block CGFloat longitutde;
    __block CLLocation *location;
    __block MKPointAnnotation * point;
    
    [geocoder geocodeAddressString:_addressString completionHandler:^(NSArray *placemarks, NSError *error) {
        
        point = [[MKPointAnnotation alloc]init];
       
            CLPlacemark *placeMark = [placemarks firstObject];
            latitude  = placeMark.location.coordinate.latitude;
            longitutde = placeMark.location.coordinate.longitude;
            maplocation = placeMark.location.coordinate;
            location = placeMark.location;
            
            
    
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, latitude, longitutde);
        [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
        
//         [_mapView setRegion:MKCoordinateRegionMakeWithDistance(location.coordinate, 200.0 , 200.0) animated:NO];
        
        // 3
        [point setCoordinate:location.coordinate];
        
        point.title =@"Event Location";
        [_mapView addAnnotation:point];
        
        [progress hide:YES];
        
    }];
    

    
}

@end
