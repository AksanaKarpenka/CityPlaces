//
//  ViewController.m
//  CityPlaces
//
//  Created by HomeStation on 8/11/17.
//  Copyright © 2017 AKS. All rights reserved.
//

#import "ViewController.h"
#import "AKSPlacesArtAnnotation.h"

@interface ViewController ()

@property (nonatomic, strong) CLLocationManager *manager;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager = [[CLLocationManager alloc] init];
    [self.manager requestWhenInUseAuthorization];
    
    self.mapView.delegate = self;
    
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"PublicArt" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
    
    NSError *error = nil;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    
    NSArray *artPlacesData = [jsonObject objectForKey:@"data"];
    
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    
    for (id artPlace in artPlacesData) {
        CLLocationCoordinate2D artPlaceCoordinate;
        
        artPlaceCoordinate.latitude = [artPlace[18] floatValue];
        artPlaceCoordinate.longitude = [artPlace[19] floatValue];
        
        if (artPlaceCoordinate.latitude == 0.0 || artPlaceCoordinate.longitude == 0.0) {
            continue;
        }
        
        NSString *title = ([artPlace[16] isKindOfClass:[NSNull class]]) ? @"??? (no place art name)" : artPlace[16];
        NSString *subtitle = ([artPlace[12] isKindOfClass:[NSNull class]]) ? @"??? (no place art location)" : artPlace[12];
        
        AKSPlacesArtAnnotation *aksPlacesArtAnnotation = [[AKSPlacesArtAnnotation alloc] initWithCoordinate:artPlaceCoordinate
                                                                                          title:title
                                                                                       subtitle:subtitle];
        [annotations addObject:aksPlacesArtAnnotation];
        
        aksPlacesArtAnnotation = nil;
        title = nil;
        subtitle = nil;
    }
    
    [self.mapView addAnnotations:annotations];
    
    annotations = nil;
    
    [self highlightActiveMapTypeBarButtonItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Bar Button Items Actions

- (IBAction)mapTypeButtonTapped:(UIBarButtonItem *)sender {
    self.mapView.mapType = sender.tag;
    
    [self highlightActiveMapTypeBarButtonItem];
}

- (IBAction)currentLocationButtonTapped:(id)sender {
    [self.manager requestWhenInUseAuthorization];
    [self.manager startUpdatingLocation];

    self.mapView.centerCoordinate = self.mapView.userLocation.location.coordinate;
}

- (void)highlightActiveMapTypeBarButtonItem {
    for (UIToolbar *barButtonItem in self.mapTypeBarButtonItemCollection) {
        if (barButtonItem.tag == self.mapView.mapType) {
            barButtonItem.tintColor = [UIColor whiteColor];
            continue;
        }
        barButtonItem.tintColor = [UIColor colorWithRed:(138 / 255.0) green:(130 / 255.0) blue:(199 / 255.0) alpha:1.0];
    }
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]] || ![annotation isKindOfClass:[AKSPlacesArtAnnotation class]]) {
        return nil;
    }
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        
    if (!pinView) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:@"CustomPinAnnotationView"];
        
        pinView.animatesDrop = YES;
        pinView.canShowCallout = YES;
        pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoLight];
    } else {
        pinView.annotation = annotation;
    }
    
    if ([annotation.title hasPrefix:@"???"]) {
        pinView.pinTintColor = [MKPinAnnotationView purplePinColor];
    } else {
        pinView.pinTintColor = [MKPinAnnotationView greenPinColor];
    }
    
    return pinView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:view.annotation.title
                                                                                 message:view.annotation.subtitle
                                                                          preferredStyle:UIAlertControllerStyleAlert];
    
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:alertAction];
    
        [self presentViewController:alertController animated:YES completion:nil];
}

@end
