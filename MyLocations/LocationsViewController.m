//
//  LocationsViewController.m
//  MyLocations
//
//  Created by RoBeRt on 14-8-28.
//  Copyright (c) 2014年 SpringShine. All rights reserved.
//

#import "LocationsViewController.h"
#import "Location.h"

@interface LocationsViewController ()

@end

@implementation LocationsViewController {
    NSArray *_locations;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    NSArray *foundObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (foundObjects == nil) {
        FATAL_CORE_DATA_ERROR(error);
        return;
    }
    
    _locations = foundObjects;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_locations count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Location"];
    
    Location *location = _locations[indexPath.row];
    
    UILabel *descriptionLabel = (UILabel *)[cell viewWithTag:100];
    descriptionLabel.text = location.locationDesctription;
    
    UILabel *addressLabel = (UILabel *)[cell viewWithTag:101];
    addressLabel.text = [NSString stringWithFormat:@"%@ %@, %@",
                         location.placemark.subThoroughfare,
                         location.placemark.thoroughfare,
                         location.placemark.locality];
    
    return cell;
}

@end
