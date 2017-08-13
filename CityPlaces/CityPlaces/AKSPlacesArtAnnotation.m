//
//  AKSPlacesArtAnnotation.m
//  CityPlaces
//
//  Created by HomeStation on 8/13/17.
//  Copyright © 2017 AKS. All rights reserved.
//

#import "AKSPlacesArtAnnotation.h"

@implementation AKSPlacesArtAnnotation

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate
                             title:(NSString *)title
                          subtitle:(NSString *)subtitle {
    if (self = [super init]) {
        _title = title;
        _subtitle = subtitle;
        _coordinate = coordinate;
    }
    
    return self;
}

@end
