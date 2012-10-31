//
//  GMSearchGamesTableViewDSDL.h
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/20/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMGamesTableViewDSDL.h"

@interface GMSearchGamesTableViewDSDL : GMGamesTableViewDSDL
{
@protected
    NSString * title_;
}

- (id) initWithTitle:(NSString *)title;
- (NSUInteger) resultsCount;

@end
