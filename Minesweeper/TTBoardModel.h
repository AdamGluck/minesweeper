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
@abstract Sees if there is a bomb at an indexPath
@param indexPath The location of the bomb on the board.
*/
-(BOOL)checkBombAtBoardPosition:(TTBoardPosition *)boardPosition;

/**
@abstract Tests to see if the board is a winning board.
*/
-(BOOL)validateBoard;

/**
@abstract Returns an array of all the indexPath's where there are bombs.
*/
-(NSArray *)bombIndexPaths;

@end
