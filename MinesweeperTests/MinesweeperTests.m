//
//  MinesweeperTests.m
//  MinesweeperTests
//
//  Created by Adam Gluck on 2/7/14.
//  Copyright (c) 2014 Adam Gluck. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TTBoardModel.h"

@interface MinesweeperTests : XCTestCase


@end

@implementation MinesweeperTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

-(void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testDefaultAllocation
{
    TTBoardModel * boardModel = [[TTBoardModel alloc] init];
    
    XCTAssert(boardModel.boardSize == 8, @"boardSize property not set properly in default allocation, should be 8");
    XCTAssert(boardModel.bombCount == 10, @"bombCount prooperty not set properly in default allocation, should be 10");
    
    NSInteger bombCount = 0;
    NSInteger boardPositionCount = 0;
    for (NSInteger i = 0; i < 8; i++){
        for (NSInteger j = 0; j < 8; j++){
            NSIndexPath * indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            TTBoardPosition * boardPosition = [boardModel boardPositionAtIndexPath:indexPath];
            if (boardPosition) boardPositionCount++;
            if (boardPosition.positionState == PositionStateBomb) bombCount++;
        }
    }
    XCTAssert(bombCount == 10, @"Bomb count didn't equal 10");
    XCTAssert(boardPositionCount == 64, @"There should be 64 board positions");
}

-(void)testCustomAllocation
{
    TTBoardModel * boardModel = [[TTBoardModel alloc] initWithBoardSize:10 andBombCount:25];
    
    XCTAssert(boardModel.boardSize == 10, @"boardSize property not set properly in default allocation, should be 10");
    XCTAssert(boardModel.bombCount == 25, @"bombCount prooperty not set properly, should be 25");
    
    NSInteger bombCount = 0;
    NSInteger boardPositionCount = 0;
    for (NSInteger i = 0; i < 10; i++){
        for (NSInteger j = 0; j < 10; j++){
            NSIndexPath * indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            TTBoardPosition * boardPosition = [boardModel boardPositionAtIndexPath:indexPath];
            if (boardPosition) boardPositionCount++;
            if (boardPosition.positionState == PositionStateBomb) bombCount++;
        }
    }
    XCTAssert(bombCount == 25, @"Bomb count didn't equal 10");
    XCTAssert(boardPositionCount == 100, @"There should be 64 board positions");
}

-(void)testVictoryCondition
{
    TTBoardModel * boardModel = [[TTBoardModel alloc] init];
    for (NSInteger i = 0; i < 8; i++){
        for (NSInteger j = 0; j < 8; j++){
            NSIndexPath * indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            TTBoardPosition * boardPosition = [boardModel boardPositionAtIndexPath:indexPath];
            if (boardPosition.positionState != PositionStateBomb) boardPosition.positionState = PositionStateChecked;
        }
    }
    XCTAssert([boardModel validateBoard], @"If all the not bomb positionStates are set then it should validate to a victory");
}

-(void)testCheckPosition
{
    TTBoardModel * boardModel = [[TTBoardModel alloc] init];
    
    NSIndexPath * arbitraryIndexPath = [NSIndexPath indexPathForItem:1 inSection:1];
    [boardModel didCheckBoardPositionAtIndexPath: arbitraryIndexPath];
    TTBoardPosition * boardPosition = [boardModel boardPositionAtIndexPath:arbitraryIndexPath];
    
    XCTAssert(boardPosition.positionState == PositionStateChecked, @"Position state not checked correctly for 1x1");
    
    arbitraryIndexPath = [NSIndexPath indexPathForItem:7 inSection:7];
    [boardModel didCheckBoardPositionAtIndexPath: arbitraryIndexPath];
    boardPosition = [boardModel boardPositionAtIndexPath:arbitraryIndexPath];
    
    XCTAssert(boardPosition.positionState == PositionStateChecked, @"Position state not checked correctly for 7x7");
    
    arbitraryIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    [boardModel didCheckBoardPositionAtIndexPath: arbitraryIndexPath];
    boardPosition = [boardModel boardPositionAtIndexPath:arbitraryIndexPath];
    
    XCTAssert(boardPosition.positionState == PositionStateChecked, @"Position state not checked correctly for 0x0");
}



@end
