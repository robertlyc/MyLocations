//
//  HubView.h
//  MyLocations
//
//  Created by RoBeRt on 14-8-26.
//  Copyright (c) 2014年 SpringShine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HudView : UIView

@property (nonatomic, strong) NSString *text;

+ (instancetype)hudView:(UIView *)view animated:(BOOL)animated;

@end
