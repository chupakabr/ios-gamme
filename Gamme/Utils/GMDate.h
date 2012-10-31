//
//  GMDate.h
//  Gamme
//
//  Created by Valeriy Chevtaev on 1/30/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMDate : NSObject

///
/// Year: 1900, 2001, 2011, ...
/// Month: 1-12
/// Day: 1-31
///
+ (NSDate *)dateWithYear:(NSInteger)year andMonth:(NSInteger)month andDay:(NSInteger)day;

+ (NSString *)mediumDate:(NSDate *)date;
+ (NSString *)longDate:(NSDate *)date;

@end
