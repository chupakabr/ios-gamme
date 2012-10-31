//
//  GMGamesTableViewDSDL.h
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/19/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMAbstractSimpleFormTableViewDSDL.h"

@interface GMGamesTableViewDSDL : GMAbstractSimpleFormTableViewDSDL
{
@protected
    NSManagedObject * model_;
}

- (id)initWithModel:(NSManagedObject *)model;

@end
