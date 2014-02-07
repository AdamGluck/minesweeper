//
//  TTBoardModel.h
//  Minesweeper
//
//  Created by Adam Gluck on 2/7/14.
//  Copyright (c) 2014 Adam Gluck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTBoardPosition.h"

@interface TTBoardModel : NSObject

/**
@abstract Creates 8x8 grid and places 10 hidden mines.
*/
-(void)resetBoard;

/**
@abstract Sees if there is a bomb at a row and column.
*/
-(BOOL)checkBombAtRow:(NSInteger)row andColumn:(NSInteger)column;

/**
@abstract Tests to see if the board is a winning board.
*/
-(BOOL)validateBoard;

/**
@abstract Returns the locations of bombs as indexPaths.
*/
-(NSMutableArray *)bombIndexPaths;

/**
@abstract Finds the number of bombs around a selectd position.
*/
-(NSInteger)numberOfBombsAroundPositionWithRow:(NSInteger)row andColumn:(NSInteger)column;



@end
