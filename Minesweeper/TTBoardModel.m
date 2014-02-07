//
//  TTBoardModel.m
//  Minesweeper
//
//  Created by Adam Gluck on 2/7/14.
//  Copyright (c) 2014 Adam Gluck. All rights reserved.
//

#import "TTBoardModel.h"

@interface TTBoardModel()

@property (strong, nonatomic) NSMutableArray * board;
@property (strong, nonatomic) NSMutableArray * bombPositions;

@end

@implementation TTBoardModel

#pragma mark - Public Methods
-(void)resetBoard {
    // allocate a board
    self.board = [[NSMutableArray alloc] initWithCapacity:8];
    for (NSInteger i = 0; i < 8; i++){
        self.board[i] = [[NSMutableArray alloc] initWithCapacity:8];
        for (NSInteger j = 0; j < 8; j++){
            TTBoardPosition * boardPosition = [[TTBoardPosition alloc] initWithPositionState:PositionStateNoBomb];
            self.board[i][j] = boardPosition;
        }
    }
    [self populateWithBombs];
}

-(BOOL)checkBombAtRow:(NSInteger)row andColumn:(NSInteger)column {
    TTBoardPosition * boardPosition = self.board[row][column];
    return boardPosition.positionState == PositionStateBomb;
}

-(BOOL)validateBoard {
    // test to see if there is a position state with no bomb
    // if there is it means that they still have to select more states
    for (NSMutableArray * row in self.board){
        for (TTBoardPosition * column in row){
            return column.positionState == PositionStateNoBomb;
        }
    }
    return NO;
}

-(NSMutableArray *)bombIndexPaths {
    NSMutableArray * bombPositions = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 8; i++){
        for (NSInteger j = 0; j < 8; j++){
            TTBoardPosition * boardPosition = self.board[i][j];
            if (boardPosition.positionState == PositionStateBomb){
                [bombPositions addObject:boardPosition];
            }
        }
    }
    return bombPositions;
}

-(NSInteger)numberOfBombsAroundPositionWithRow:(NSInteger)row andColumn:(NSInteger)column
{
    NSInteger nBombs = 0;
    for (NSInteger i = -1; i < 2; i++){
        if (row + i >= 0 && row + i <= 7){
            for (NSInteger k = -1; k < 2; k++){
                if (column + k >= 0 && column + k <= 7){
                    TTBoardPosition * boardPosition = self.board[row + i][column + k];
                    if (boardPosition.positionState == PositionStateBomb) nBombs++;
                }
            }
        }
    }
    return nBombs;
}

#pragma mark - Public Method Helpers

-(void)populateWithBombs
{
    NSInteger numberOfBombsPlaced = 0;
    while (numberOfBombsPlaced < 10) {
        // randomly select board position row and column numbers
        NSInteger row = (NSInteger) arc4random_uniform(8);
        NSInteger column = (NSInteger) arc4random_uniform(8);
        TTBoardPosition * randomBoardPosition = self.board[row][column];
        if (randomBoardPosition.positionState != PositionStateBomb){
            randomBoardPosition.positionState = PositionStateBomb;
            numberOfBombsPlaced++;
        }
    }
}

@end
