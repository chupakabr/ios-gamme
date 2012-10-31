//
//  Platform.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 1/23/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "Platform.h"
#import "Game.h"
#import "Link.h"


@implementation Platform

@dynamic title;
@dynamic site;
@dynamic releaseDate;
@dynamic gameShopLinks;
@dynamic games;
@dynamic isSystem;


- (NSString *) description
{
    return [NSString stringWithFormat:@"Platform: title(%@) site(%@) releaseDate(%@)",
                                self.title, self.site, self.releaseDate];
}


#pragma mark - My custom huerga

- (void) prepareAndUpdateGameShopLinks:(NSSet *)values
{
    NSManagedObjectContext * moc = self.managedObjectContext;
    
    if (moc) {
        
        // Update existing values
        
        for (Link * lnk in values) {
            if (![[self gameShopLinks] containsObject:lnk]) {
                [moc insertObject:lnk];
            }
        }
        
        for (Link * lnk in [self gameShopLinks]) {
            if (![values containsObject:lnk]) {
                [moc deleteObject:lnk];
            }
        }
    }
    
    [self addGameShopLinks:values];
}

@end
