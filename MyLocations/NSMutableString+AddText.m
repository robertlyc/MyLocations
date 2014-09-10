//
//  NSMutableString+AddText.m
//  MyLocations
//
//  Created by RoBeRt on 14-9-10.
//  Copyright (c) 2014年 SpringShine. All rights reserved.
//

#import "NSMutableString+AddText.h"

@implementation NSMutableString (AddText)

- (void)addText:(NSString *)text withSeparator:(NSString *)separator {
    if (text != nil) {
        if (self.length > 0) {
            [self appendString:separator];
        }
        [self appendString:text];
    }
}

@end
