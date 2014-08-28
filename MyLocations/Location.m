//
//  Location.m
//  MyLocations
//
//  Created by RoBeRt on 14-8-26.
//  Copyright (c) 2014年 SpringShine. All rights reserved.
//

#import "Location.h"


@implementation Location

@dynamic latitude;
@dynamic longtitude;
@dynamic date;
@dynamic locationDesctription;
@dynamic category;
@dynamic placemark;

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longtitude doubleValue]);
}

- (NSString *)title {
    if ([self.locationDesctription length] > 0) {
        return self.locationDesctription;
    } else {
        return @"(No Description)";
    }
}

- (NSString *)subtitle {
    return self.category;
}

@end
