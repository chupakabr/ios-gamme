//
//  GMLinksSimpleFormTableViewDSDL.h
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/3/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMAbstractSimpleFormTableViewDSDL.h"

@interface GMLinksSimpleFormTableViewDSDL : GMAbstractSimpleFormTableViewDSDL
{
@protected
    NSMutableSet * updatedData_;
}

- (id)initWithResultKey:(NSString *)resultDataKey andData:(NSSet *)data;

// Specific
- (void) applyNewData;

@end
