//
//  MyTabBarController.m
//  MyLocations
//
//  Created by RoBeRt on 14-9-11.
//  Copyright (c) 2014年 SpringShine. All rights reserved.
//

#import "MyTabBarController.h"

@interface MyTabBarController ()

@end

@implementation MyTabBarController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return nil;
}


@end