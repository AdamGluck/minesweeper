//
//  TTBoardPosition.m
//  Minesweeper
//
//  Created by Adam Gluck on 2/7/14.
//  Copyright (c) 2014 Adam Gluck. All rights reserved.
//

#import "TTBoardPosition.h"

@implementation TTBoardPosition
-(id)initWithPositionState:(PositionState)positionState {
    self = [super init];
    if (self){
        self.positionState = positionState;
    }
    return self;
}

@end
