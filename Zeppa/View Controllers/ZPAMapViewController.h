//
//  ZPAMapViewController.h
//  Zeppa
//
//  Created by Faran on 30/06/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ZPAMapViewController : UIViewController<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong , nonatomic) NSString * addressString;


@end
