//
//  Author.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 1/23/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "Author.h"
#import "Game.h"


@implementation Author

@dynamic title;
@dynamic site;
@dynamic country;
@dynamic foundationDate;
@dynamic closeDate;
@dynamic games;
@dynamic isSystem;


- (NSString *) description
{
    return [NSString stringWithFormat:@"Author: title(%@) site(%@) country(%@) foundationDate(%@) closeDate(%@)",
                                self.title, self.site, self.country, self.foundationDate, self.closeDate];
}



@end
