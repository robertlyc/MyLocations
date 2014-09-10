//
//  Location.m
//  MyLocations
//
//  Created by RoBeRt on 14-8-26.
//  Copyright (c) 2014年 SpringShine. All rights reserved.
//

#import "Location.h"


@implementation Location

@dynamic photoId;
@dynamic latitude;
@dynamic longitude;
@dynamic date;
@dynamic locationDescription;
@dynamic category;
@dynamic placemark;

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
}

- (NSString *)title {
    if ([self.locationDescription length] > 0) {
        return self.locationDescription;
    } else {
        return @"(No Description)";
    }
}

- (NSString *)subtitle {
    return self.category;
}

- (BOOL)hasPhoto {
    return (self.photoId != nil) && ([self.photoId integerValue] != -1);
}

- (NSString *)documentsDiretory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths lastObject];
    return documentsDirectory;
}

- (NSString *)photoPath {
    NSString *filename = [NSString stringWithFormat:@"Photo-%d.jpg", [self.photoId integerValue]];
    
    return [[self documentsDiretory] stringByAppendingPathComponent:filename];
}

- (UIImage *)photoImage {
    NSAssert(self.photoId != nil, @"No Photo ID set");
    NSAssert([self.photoId integerValue] != -1, @"Photo ID is -1");
    return [UIImage imageWithContentsOfFile:[self photoPath]];
}

+ (NSInteger)nextPhotoId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger photoId = [defaults integerForKey:@"PhotoID"];
    [defaults setInteger:photoId+1 forKey:@"PhotoID"];
    [defaults synchronize];
    return photoId;
}

- (void)removePhotoFile {
    NSString *path = [self photoPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error;
        if (![fileManager removeItemAtPath:path error:&error]) {
            NSLog(@"Error moving file: %@", error);
        }
    }
}

@end
