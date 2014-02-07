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
    self.bombPositions = [self randomBoardPositionsInRange:8];
    
    // populate board
    for (int i = 0; i < 8; i++){
        self.board[i] = [[NSMutableArray alloc] initWithCapacity:8];
        for (int j = 0; j < 8; j++){
            
            // check if this position should contain a bomb
            BOOL isPositionOfBomb = NO;
            for (TTBoardPosition * bombPosition in self.bombPositions){
                if (bombPosition.row == i && bombPosition.column == j){
                    isPositionOfBomb = YES;
                }
            }
            
            // marke true if it should, false if it shouldn't
            if (isPositionOfBomb){
                self.board[i][j] = @1;
            } else {
                self.board[i][j] = @0;
            }
            
        }
    }
}

-(BOOL)checkBombAtBoardPosition:(TTBoardPosition *)boardPosition {
    
    return NO;
}

-(BOOL)validateBoard{
    return NO;
}

-(NSArray *)bombIndexPaths {
    return self.bombPositions;
}

#pragma mark - Public Method Helpers

-(NSMutableArray *)randomBoardPositionsInRange:(NSInteger)range
{
    NSMutableArray * boardPositionArray = [[NSMutableArray alloc] init];
    
    while (boardPositionArray.count < 8) {
        
        // randomly select board position row and column numbers
        NSInteger row = (NSInteger) arc4random_uniform(range);
        NSInteger column = (NSInteger) arc4random_uniform(range);
        TTBoardPosition * newBoardPosition = [[TTBoardPosition alloc] initWithRow:row andColumn:column];
        
        // check if new board position is unique by iterating through existing board positions
        BOOL newBoardPositionUnique = YES;
        for (TTBoardPosition * boardPosition in boardPositionArray){
            if (boardPosition.row == newBoardPosition.row && boardPosition.column == newBoardPosition.column){
                newBoardPositionUnique = NO;
                break;
            }
        }
        
        // if it is unique add it to the board position array
        if (newBoardPositionUnique){
            [boardPositionArray addObject:newBoardPosition];
        }
    }
    
    // return the board positions
    return boardPositionArray;
}

@end
