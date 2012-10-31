//
//  GMLog.h
//  Gamme
//
//  Created by Valeriy Chevtaev on 1/23/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#ifndef Gamme_GMLog_h
#define Gamme_GMLog_h

#ifdef DEBUG
# define GMLog(args...) 
//NSLog(args)
#else
# define GMLog(args...) 
#endif

#ifdef DEBUG
# define GMError(args...) 
//NSLog(args)
#else
# define GMError(args...) 
#endif

#endif
