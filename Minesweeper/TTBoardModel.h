//
//  TTBoardModel.h
//  Minesweeper
//
//  Created by Adam Gluck on 2/7/14.
//  Copyright (c) 2014 Adam Gluck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTBoardPosition.h"

/**
@discussion A TTBoardModel object handles the rules of a Minesweeper game. It should be ideally used as a dataSource model object for a UICollectionView, but could be adopted to any purpose. Its underlying data model is an array, that is accessed through indexPaths whose sections correspond to the rows of a board, and whose items correspond to the columns.
*/

@interface TTBoardModel : NSObject

/**
@abstract Initiate a board and set the boardSize and bombCount.
@param boardSize The dimensions of the board.
@param bombCount The number of hidden bombs on the board.
@discussion The board is automatically populated when it is initialized. Note, bombCount cannot be larger than the number of tiles. If there are more bombs than tiles bombCount defaults to the number of tiles in the board.
*/
-(id)initWithBoardSize:(NSInteger)boardSize andBombCount:(NSInteger)bombCount;

/**
@abstract The number of columns and rows in the board.
@discussion Defaults to 8.
*/
@property (assign, nonatomic) NSInteger boardSize;

/**
@abstract The number of bombs.
@discussion Defaults to 10.
*/
@property (assign, nonatomic) NSInteger bombCount;

/**
@abstract Creates 8x8 grid and places 10 hidden mines.
*/
-(void)resetBoard;

/**
 @abstract Tests to see if the board is a winning board.
 @discussion Winning is defined as every position that is not a bomb has been revealed. The viewController is responsible for telling the model when positions have been revealed.
 */
-(BOOL)validateBoard;

/**
 @abstract Returns the locations of bombs as indexPaths.
 */
-(NSMutableArray *)bombIndexPaths;

/**
@abstract Sees if there is a bomb at a row and column.
@param indexPath An NSIndexPath object with an item and a section.
*/
-(BOOL)checkBombAtIndexPath:(NSIndexPath *)indexPath;

/**
@abstract Indicates to the model that a board position has been revealed.
@param indexPath The NSIndexPath object with the item and section of the revealed tile.
*/
-(void)didCheckBoardPositionAtIndexPath:(NSIndexPath *)indexPath;

/**
@abstract Finds the number of bombs around a selectd position.
@param indexPath An NSIndexPath object with an item and a section.
*/
-(NSInteger)checkNumberOfBombsAroundPositionWithIndexPath:(NSIndexPath *)indexPath;

/**
@abstract Finds indexPaths for the tiles that surround a particular position.
@param indexPath An NSIndexPath object with an item and a section.
*/
-(NSMutableArray *)indexPathsAroundPositionAtIndexPath:(NSIndexPath *)indexPath;

/**
@abstract Returns the boardPosition at an indexPath.
@param indexPath An NSIndexPath object with an item and a section.
*/

-(TTBoardPosition *)boardPositionAtIndexPath:(NSIndexPath *)indexPath;



@end
