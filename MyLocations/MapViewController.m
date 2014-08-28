//
//  MapViewController.m
//  MyLocations
//
//  Created by RoBeRt on 14-8-28.
//  Copyright (c) 2014年 SpringShine. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController {
    NSArray *_locations;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateLocations];
}

- (IBAction)showUser:(id)sender {
   MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate, 1000, 1000);
    
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

- (IBAction)showLocations:(id)sender {
    
}

- (void)updateLocations {
     NSEntityDescription *entity = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *foundObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (foundObjects == nil) {
        FATAL_CORE_DATA_ERROR(error);
        return;
    }
    
    if (_locations != nil) {
        [self.mapView removeAnnotations:_locations];
    }
    
    _locations = foundObjects;
    [self.mapView addAnnotations:_locations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
