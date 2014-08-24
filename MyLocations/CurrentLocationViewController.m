//
//  FirstViewController.m
//  MyLocations
//
//  Created by RoBeRt on 14-8-21.
//  Copyright (c) 2014年 SpringShine. All rights reserved.
//

#import "CurrentLocationViewController.h"

@interface CurrentLocationViewController ()

@end

@implementation CurrentLocationViewController {
    CLLocationManager *_locationManager;
    CLLocation *_location;
    BOOL _updatingLocation;
    NSError *_lastLocationError;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self updateLabels];
    [self configureGetButton];
}

- (IBAction)getLocation:(id)sender {
    if (_updatingLocation) {
        [self stopLocationManager];
    } else {
        _location = nil;
        _lastLocationError = nil;
        
        [self startLocationManager];
    }

    [self updateLabels];
    [self configureGetButton];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailwithError %@", error);
    
    if (error.code == kCLErrorLocationUnknown) {
        return;
    }
    
    [self stopLocationManager];
    _lastLocationError = error;
    
    [self updateLabels];
    [self configureGetButton];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *newlocation = [locations lastObject];
    NSLog(@"didUpdateLocations %@", newlocation);
    
    if ([newlocation.timestamp timeIntervalSinceNow] < -5.0) {
        return;
    }
    
    if (newlocation.horizontalAccuracy < 0) {
        return;
    }
    
    if (_location == nil || _location.horizontalAccuracy > newlocation.horizontalAccuracy) {
        _lastLocationError = nil;
        _location = newlocation;
        [self updateLabels];
        
        if (newlocation.horizontalAccuracy <= _locationManager.desiredAccuracy) {
            NSLog(@"*** We're done!");
            [self stopLocationManager];
            [self configureGetButton];
        }
    }
}

#pragma mark - UpdateLabels
- (void)updateLabels {
    if (_location != nil) {
        self.latitudeLabel.text = [NSString stringWithFormat:@"%.8f", _location.coordinate.latitude];
        self.LongtitudeLabel.text = [NSString stringWithFormat:@"%.8f", _location.coordinate.longitude];
        self.tagButton.hidden = NO;
        self.messageLabel.text = @"";
    } else {
        self.latitudeLabel.text = @"";
        self.LongtitudeLabel.text = @"";
        self.tagButton.hidden = YES;
        
        NSString *statusMessage;
        if (_lastLocationError != nil) {
            if ([_lastLocationError.domain isEqualToString:kCLErrorDomain] && _lastLocationError.code == kCLErrorDenied) {
                statusMessage = @"Location Services Diabled";
            } else {
                statusMessage = @"Error Getting Location";
            }
        } else if (![CLLocationManager locationServicesEnabled]) {
            statusMessage = @"Location Services Diabled";
        } else if (_updatingLocation) {
            statusMessage = @"Searching...";
        } else {
            statusMessage = @"Press the button to start";
        }

        self.messageLabel.text = statusMessage;
    }
}

- (void)configureGetButton {
    if (_updatingLocation) {
        [self.getButton setTitle:@"Stop" forState:UIControlStateNormal];
    } else {
        [self.getButton setTitle:@"Get My Location" forState:UIControlStateNormal];
    }
}

- (void)startLocationManager {
    if ([CLLocationManager locationServicesEnabled]) {
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        [_locationManager startUpdatingLocation];
        _updatingLocation = YES;
    }
}

- (void)stopLocationManager {
    if (_updatingLocation) {
        [_locationManager stopUpdatingLocation];
        _locationManager.delegate = nil;
        _updatingLocation = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
