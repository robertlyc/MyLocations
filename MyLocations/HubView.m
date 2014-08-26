//
//  HubView.m
//  MyLocations
//
//  Created by RoBeRt on 14-8-26.
//  Copyright (c) 2014年 SpringShine. All rights reserved.
//

#import "HubView.h"

@implementation HubView

+ (instancetype)hudView:(UIView *)view animated:(BOOL)animated {
    HubView *hubView = [[HubView alloc] initWithFrame:view.bounds];
    hubView.opaque = NO;
    
    [view addSubview:hubView];
    view.userInteractionEnabled = NO;
    
    hubView.backgroundColor = [UIColor colorWithRed:1.0f green:0 blue:0 alpha:0.5f];
    return hubView;
}

@end
