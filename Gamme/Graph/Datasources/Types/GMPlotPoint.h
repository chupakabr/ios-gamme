//
//  GMPlotPoint.h
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/25/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMPlotPoint : NSObject

@property (assign, nonatomic, readwrite) NSInteger x;
@property (assign, nonatomic, readwrite) NSInteger y;

@property (retain, nonatomic, readonly) NSNumber * xNumber;
@property (retain, nonatomic, readonly) NSNumber * yNumber;

- (id) initWithX:(NSInteger)x andY:(NSInteger)y;
+ (id) plotPointWithX:(NSInteger)x andY:(NSInteger)y;

@end
