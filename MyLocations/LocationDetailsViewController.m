//
//  LocationDetailsViewController.m
//  MyLocations
//
//  Created by RoBeRt on 14-8-25.
//  Copyright (c) 2014年 SpringShine. All rights reserved.
//

#import "LocationDetailsViewController.h"

@interface LocationDetailsViewController ()

@property (nonatomic, weak) IBOutlet UITextView *deescriptionTextView;
@property (nonatomic, weak) IBOutlet UILabel *categoryLabel;
@property (nonatomic, weak) IBOutlet UILabel *latitudeLabel;
@property (nonatomic, weak) IBOutlet UILabel *longtitudeLabel;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;

@end

@implementation LocationDetailsViewController

- (IBAction)done:(id)sender {
    [self closeScreeen];
}

- (IBAction)cancel:(id)sender {
    [self closeScreeen];
}

- (void)closeScreeen {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
