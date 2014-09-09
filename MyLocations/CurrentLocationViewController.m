//
//  FirstViewController.m
//  MyLocations
//
//  Created by RoBeRt on 14-8-21.
//  Copyright (c) 2014年 SpringShine. All rights reserved.
//

#import "CurrentLocationViewController.h"
#import "LocationDetailsViewController.h"

@interface CurrentLocationViewController () 

@end

@implementation CurrentLocationViewController {
    CLLocationManager *_locationManager;
    CLLocation *_location;
    BOOL _updatingLocation;
    NSError *_lastLocationError;
    
    CLGeocoder *_geocoder;
    CLPlacemark *_placemark;
    BOOL _performingReverseGeocoding;
    NSError *_lastGeocodingError;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _locationManager = [[CLLocationManager alloc] init];
        _geocoder = [[CLGeocoder alloc] init];
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
        _placemark = nil;
        _lastGeocodingError = nil;
        
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
    
    CLLocationDistance distance = MAXFLOAT;
    if (_location != nil) {
        distance = [newlocation distanceFromLocation:_location];
    }
    
    if (_location == nil || _location.horizontalAccuracy > newlocation.horizontalAccuracy) {
        _lastLocationError = nil;
        _location = newlocation;
        [self updateLabels];
        
        if (newlocation.horizontalAccuracy <= _locationManager.desiredAccuracy) {
            NSLog(@"*** We're done!");
            [self stopLocationManager];
            [self configureGetButton];
            
            if (distance > 0) {
                _performingReverseGeocoding = NO;
            }
        }
        
        if (!_performingReverseGeocoding) {
            NSLog(@"*** Going to geocode");
            
            _performingReverseGeocoding = YES;
            [_geocoder reverseGeocodeLocation:_location completionHandler:^(NSArray *placemarks, NSError *error) {
                NSLog(@"*** Found placemarks: %@, error %@", placemarks, error);
                
                _lastLocationError = error;
                if (error == nil && [placemarks count] > 0) {
                    _placemark = [placemarks lastObject];
                } else {
                    _placemark = nil;
                }
                
                _performingReverseGeocoding = NO;
                [self updateLabels];
            }];
        }
    } else if (distance < 1.0) {
        NSTimeInterval timeInterval = [newlocation.timestamp timeIntervalSinceNow];
        if (timeInterval > 10) {
            NSLog(@"*** Force done!");
            [self stopLocationManager];
            [self updateLabels];
            [self configureGetButton];
        }
    }
}

#pragma mark - UpdateLabels
- (void)updateLabels {
    if (_location != nil) {
        self.latitudeLabel.text = [NSString stringWithFormat:@"%.8f", _location.coordinate.latitude];
        self.longitudeLabel.text = [NSString stringWithFormat:@"%.8f", _location.coordinate.longitude];
        self.tagButton.hidden = NO;
        self.messageLabel.text = @"";
        
        if (_placemark != nil) {
            self.addressLabel.text = [self stringFromPlacemark:_placemark];
        } else if (_performingReverseGeocoding) {
            self.addressLabel.text = @"Searching for Address...";
        } else if (_lastGeocodingError != nil) {
            self.addressLabel.text = @"Error Finding Address";
        } else {
            self.addressLabel.text = @"No Address Found";
        }
        
    } else {
        self.latitudeLabel.text = @"";
        self.longitudeLabel.text = @"";
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
        
        [self performSelector:@selector(didTimeOut:) withObject:nil afterDelay:60];
    }
}

- (void)stopLocationManager {
    if (_updatingLocation) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(didTimeOut:) object:nil];
        
        [_locationManager stopUpdatingLocation];
        _locationManager.delegate = nil;
        _updatingLocation = NO;
        
    }
}

- (void)didTimeOut:(id)obj {
    NSLog(@"*** Time out");
    if (_location == nil) {
        [self stopLocationManager];
        _lastLocationError = [NSError errorWithDomain:@"MyLocationErrorDomain" code:1 userInfo:nil];
        [self updateLabels];
        [self configureGetButton];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TagLocation"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        LocationDetailsViewController *controller = (LocationDetailsViewController *)navigationController.topViewController;
        
        controller.coordinate = _location.coordinate;
        controller.placemark = _placemark;
        controller.managedObjectContext = self.managedObjectContext;
    }
}

#pragma mark - Utility
- (NSString *)stringFromPlacemark:(CLPlacemark *)thePlacemark {
    return [NSString stringWithFormat:@"%@ %@\n%@ %@ %@", thePlacemark.subThoroughfare, thePlacemark.thoroughfare, thePlacemark.locality, thePlacemark.administrativeArea, thePlacemark.postalCode];
}

@end
