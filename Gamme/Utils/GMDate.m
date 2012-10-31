//
//  GMDate.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 1/30/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMDate.h"

@implementation GMDate

+ (NSDate *)dateWithYear:(NSInteger)year andMonth:(NSInteger)month andDay:(NSInteger)day
{
    NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
    [comps setYear:year];
    [comps setMonth:month];
    [comps setDay:day];
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:0];
    
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

+ (NSString *)mediumDate:(NSDate *)date
{
    return [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];    
}

+ (NSString *)longDate:(NSDate *)date
{
    return [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterNoStyle];    
}

@end
