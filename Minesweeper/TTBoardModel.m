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

#define DEFAULT_BOARD_SIZE 8
#define DEFAULT_BOMB_COUNT 10

-(id)init {
    self = [super init];
    if (self){
        self.boardSize = DEFAULT_BOARD_SIZE;
        self.bombCount = DEFAULT_BOMB_COUNT;
        [self resetBoard];
    }
    return self;
}

-(id)initWithBoardSize:(NSInteger)boardSize andBombCount:(NSInteger)bombCount {
    self = [super init];
    if (self){
        NSInteger numberOfTiles = boardSize * boardSize;
        if (bombCount > numberOfTiles) bombCount = numberOfTiles;
        self.boardSize = boardSize;
        self.bombCount = bombCount;
        [self resetBoard];
    }
    return self;
}

#pragma mark - Public Methods

-(void)resetBoard {
    // allocate a board
    self.board = [[NSMutableArray alloc] initWithCapacity:self.boardSize];
    [self populateBoardArray];
    [self populateWithRandomBombs];
}

-(BOOL)checkBombAtIndexPath:(NSIndexPath *)indexPath {
    TTBoardPosition * boardPosition = [self boardPositionAtIndexPath:indexPath];
    return boardPosition.positionState == PositionStateBomb;
}

-(void)didCheckBoardPositionAtIndexPath:(NSIndexPath *)indexPath
{
    TTBoardPosition * boardPosition = [self boardPositionAtIndexPath:indexPath];
    boardPosition.positionState = PositionStateChecked;
}

-(BOOL)validateBoard {
    // test to see if there is a position state of NoBomb meaning it hasn't been selected
    for (NSMutableArray * row in self.board){
        for (TTBoardPosition * column in row){
            if (column.positionState == PositionStateNoBomb){
                return NO;
            }
        }
    }
    return YES;
}

-(NSMutableArray *)bombIndexPaths {
    NSMutableArray * bombPositions = [NSMutableArray array];
    for (NSInteger i = 0; i < self.boardSize; i++){
        for (NSInteger j = 0; j < self.boardSize; j++){
            TTBoardPosition * boardPosition = self.board[i][j];
            if (boardPosition.positionState == PositionStateBomb){
                NSIndexPath * bombIndexPath = [self indexPathFromArrayRow:i andColumn:j];
                [bombPositions addObject:bombIndexPath];
            }
        }
    }
    return bombPositions;
}

-(NSInteger)checkNumberOfBombsAroundPositionWithIndexPath:(NSIndexPath *)indexPath {
    // see the method boardPositionAtIndexPath for more on this sort of conversion
    NSInteger bombCount = 0;
    NSMutableArray * bombIndexPaths = [self indexPathsAroundPositionAtIndexPath:indexPath];
    for (NSIndexPath * indexPath in bombIndexPaths){
        TTBoardPosition * boardPosition = [self boardPositionAtIndexPath:indexPath];
        if (boardPosition.positionState == PositionStateBomb) bombCount++;
    }
    return bombCount;
}

-(NSMutableArray *)indexPathsAroundPositionAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger arrayRow = indexPath.section;
    NSInteger arrayColumn = indexPath.row;
    NSMutableArray * indexPaths = [NSMutableArray array];
    for (NSInteger i = -1; i < 2; i++){
        if (arrayRow + i >= 0 && arrayRow + i < self.boardSize){
            for (NSInteger j = -1; j < 2; j++){
                if (arrayColumn + j >= 0 && arrayColumn + j < self.boardSize){
                    NSIndexPath * indexPath = [self indexPathFromArrayRow: (arrayRow + i) andColumn:(arrayColumn + j)];
                    [indexPaths addObject:indexPath];
                }
            }
        }
    }
    return indexPaths;
}

-(TTBoardPosition *)boardPositionAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger arrayRow = indexPath.section;
    NSInteger arrayColumn = indexPath.row;
    TTBoardPosition * boardPosition = self.board[arrayRow][arrayColumn];
    return boardPosition;
}

#pragma mark - Public Method Helpers

-(void)populateBoardArray {
    for (NSInteger i = 0; i < self.boardSize; i++){
        self.board[i] = [[NSMutableArray alloc] initWithCapacity:self.boardSize];
        for (NSInteger j = 0; j < self.boardSize; j++){
            TTBoardPosition * boardPosition = [[TTBoardPosition alloc] initWithPositionState:PositionStateNoBomb];
            self.board[i][j] = boardPosition;
        }
    }
}

-(void)populateWithRandomBombs {
    NSInteger numberOfBombsPlaced = 0;
    while (numberOfBombsPlaced < self.bombCount) {
        NSInteger row = (NSInteger) arc4random_uniform(self.boardSize);
        NSInteger column = (NSInteger) arc4random_uniform(self.boardSize);
        TTBoardPosition * randomBoardPosition = self.board[row][column];
        if (randomBoardPosition.positionState != PositionStateBomb){
            randomBoardPosition.positionState = PositionStateBomb;
            numberOfBombsPlaced++;
        }
    }
}

// just to make the conversion clearer
-(NSIndexPath *)indexPathFromArrayRow:(NSInteger)row andColumn:(NSInteger)column {
    return [NSIndexPath indexPathForItem:column inSection:row];
}

@end
