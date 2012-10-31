//
//  GMNib.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 1/31/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMNib.h"

@implementation GMNib

+ (NSString *)getNibName:(NSString *)nibPrefix
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        // iPhone
        return [NSString stringWithFormat:@"%@_iPhone", nibPrefix];
    } else {
        // iPad
        return [NSString stringWithFormat:@"%@_iPad", nibPrefix];
    }
}

+ (NSString *)getBgImageName
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        // iPhone
        return @"common-bg.png";
    } else {
        // iPad
        return @"common-bg-ipad.png";
    }
}

@end
