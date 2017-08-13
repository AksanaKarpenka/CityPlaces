//
//  ViewController.h
//  CityPlaces
//
//  Created by HomeStation on 8/11/17.
//  Copyright © 2017 AKS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) IBOutletCollection(UIBarButtonItem) NSArray *mapTypeBarButtonItemCollection;

@end

