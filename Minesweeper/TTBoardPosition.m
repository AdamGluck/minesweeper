//
//  TTBoardPosition.m
//  Minesweeper
//
//  Created by Adam Gluck on 2/7/14.
//  Copyright (c) 2014 Adam Gluck. All rights reserved.
//

#import "TTBoardPosition.h"

@implementation TTBoardPosition
-(id)initWithRow:(NSInteger)row andColumn:(NSInteger)column
{
    self = [super init];
    if (self){
        self.row = row;
        self.column = column;
    }
    return self;
}

@end
