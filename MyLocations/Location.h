//
//  Location.h
//  MyLocations
//
//  Created by RoBeRt on 14-8-26.
//  Copyright (c) 2014年 SpringShine. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Location : NSManagedObject <MKAnnotation>

@property (nonatomic, retain) NSNumber * photoId;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longtitude;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * locationDesctription;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) CLPlacemark *placemark;

+ (NSInteger)nextPhotoId;

- (BOOL)hasPhoto;
- (NSString *)photoPath;
- (UIImage *)photoImage;

@end
