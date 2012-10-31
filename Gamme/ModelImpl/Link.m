//
//  Link.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 1/23/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "Link.h"
#import "Game.h"
#import "Platform.h"


@implementation Link

@dynamic title;
@dynamic url;
@dynamic platform;
@dynamic game;


- (NSString *) description
{
    return [NSString stringWithFormat:@"Link(%@ - %@)", self.title, self.url];
}

@end
