//
//  TTBoardPosition.h
//  Minesweeper
//
//  Created by Adam Gluck on 2/7/14.
//  Copyright (c) 2014 Adam Gluck. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTBoardPosition : NSObject

-(id)initWithRow:(NSInteger)row andColumn:(NSInteger)column;
@property (assign, nonatomic) NSInteger row;
@property (assign, nonatomic) NSInteger column;

@end
