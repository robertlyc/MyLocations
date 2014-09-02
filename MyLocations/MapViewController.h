//
//  MapViewController.h
//  MyLocations
//
//  Created by RoBeRt on 14-8-28.
//  Copyright (c) 2014年 SpringShine. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MapViewController : UIViewController <MKMapViewDelegate, UINavigationBarDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
