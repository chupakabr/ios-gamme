//
//  Genre.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/23/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "Genre.h"
#import "Game.h"


@implementation Genre

@dynamic title;
@dynamic games;
@dynamic isSystem;


- (NSString *) description
{
    return [NSString stringWithFormat:@"Genre(%@)", self.title];
}

@end
