//
//  TTBoardPosition.h
//  Minesweeper
//
//  Created by Adam Gluck on 2/7/14.
//  Copyright (c) 2014 Adam Gluck. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    PositionStateNoBomb,
    PositionStateBomb,
    PositionStateSelected,
} PositionState;

@interface TTBoardPosition : NSObject

-(id)initWithPositionState:(PositionState) positionState;
@property (assign, nonatomic) PositionState positionState;

@end
