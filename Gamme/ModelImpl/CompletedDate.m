//
//  CompletedDate.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 1/27/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "CompletedDate.h"
#import "Game.h"


@implementation CompletedDate

@dynamic completedDate;
@dynamic note;
@dynamic game;


- (NSString *) description
{
    return [NSString stringWithFormat:@"CompletedDate(%@, note[%@])", self.completedDate, self.note];
}

@end
