//
//  GameState.h
//  Gamme
//
//  Created by Valeriy Chevtaev on 1/23/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#ifndef Gamme_GameState_h
#define Gamme_GameState_h

typedef enum game_state_st_ {
    GM_STATE_NOT_COMPLETED = 0,
    GM_STATE_PLANNED = 1,
    GM_STATE_IN_PROGRESS = 2,
    GM_STATE_COMPLETED = 3
} GameState;

#endif
