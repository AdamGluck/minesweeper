//
//  TTBoardViewController.m
//  Minesweeper
//
//  Created by Adam Gluck on 2/9/14.
//  Copyright (c) 2014 Adam Gluck. All rights reserved.
//

#import "TTBoardViewController.h"
#import "TTBoardModel.h"

@interface TTBoardViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate>

@property (strong, nonatomic) TTBoardModel * board;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField *boardSizeField;
@property (weak, nonatomic) IBOutlet UITextField *bombCountField;
@property (strong, nonatomic) UITapGestureRecognizer * tapGesture;

@end

@implementation TTBoardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTextFieldKeyboardInteraction];
}

#pragma mark - Handle Keyboard
-(void)configureTextFieldKeyboardInteraction {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.view addGestureRecognizer:self.tapGesture];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [self.view removeGestureRecognizer:self.tapGesture];
}

-(void)backgroundTapped:(UITapGestureRecognizer *)recognizer {
    [self.view endEditing:YES];
}

// this is a bit of code I found here: http://stackoverflow.com/questions/18957476/ios-7-keyboard-animation that deals with an undocumented animation curve of the keyboard in iOS 7
-(void)keyboardWillShown:(NSNotification *)notification {
    NSDictionary * keyboardInfo = notification.userInfo;
    CGSize keyboardSize = [keyboardInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[keyboardInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.center = CGPointMake(self.view.center.x, self.view.center.y - keyboardSize.height);
    [UIView commitAnimations];
}

-(void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary * keyboardInfo = notification.userInfo;
    CGSize keyboardSize = [keyboardInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[keyboardInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.center = CGPointMake(self.view.center.x, self.view.center.y + keyboardSize.height);
    [UIView commitAnimations];
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.board.boardSize;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return self.board.boardSize;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"BoardCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

#pragma mark - UIColectionView Delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.board checkBombAtIndexPath:indexPath]){
        [self resetGame];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"You Lose!" message:@"You hit a bomb! You should be more careful next time." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alert show];
    } else {
        [self makeMoveAtIndexPath:indexPath];
    }
}

#pragma mark - UICollectionView helper functions
-(void)makeMoveAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger bombCount = [self.board checkNumberOfBombsAroundPositionWithIndexPath:indexPath];
    [self revealBombCount:bombCount forCellAtIndexPath:indexPath];
    
    if (!bombCount){
        NSMutableArray * surroundingTiles = [self.board indexPathsAroundPositionAtIndexPath:indexPath];
        [self handleZeroWithSurroundingTiles:surroundingTiles];
    }
}

-(void)handleZeroWithSurroundingTiles:(NSMutableArray *)surroundingTiles {
    // this keeps track of the tiles we have visited
    NSMutableArray * visitedTiles = [NSMutableArray array];
    
    while (surroundingTiles.count) {
        NSIndexPath * surroundingTileIndexPath = (NSIndexPath *)surroundingTiles.lastObject;
        [visitedTiles addObject:surroundingTileIndexPath];
        [surroundingTiles removeLastObject];
        
        NSInteger bombCount = [self.board checkNumberOfBombsAroundPositionWithIndexPath:surroundingTileIndexPath];
        [self revealBombCount:bombCount forCellAtIndexPath:surroundingTileIndexPath];
        
        if (!bombCount){
            NSMutableArray * additionalTiles = [self.board indexPathsAroundPositionAtIndexPath:surroundingTileIndexPath];
            for (NSIndexPath * additionalTile in additionalTiles){
                if (![visitedTiles containsObject:additionalTile]){
                    [surroundingTiles addObject:additionalTile];
                }
            }
        }
    }
}

-(void)revealBombCount:(NSInteger)bombCount forCellAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell * cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    CGSize cellSize = [self collectionViewCellSize];
    UILabel * bombCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cellSize.height / 1.5, cellSize.height / 1.5)];
    bombCountLabel.font = [UIFont systemFontOfSize:cellSize.height / 1.5];
    bombCountLabel.text = [NSString stringWithFormat:@"%d", bombCount];
    [bombCountLabel sizeToFit];
    bombCountLabel.center = CGPointMake(cellSize.width / 2, cellSize.height / 2);
    [cell.contentView addSubview:bombCountLabel];
}

#pragma mark - UIButton Actions

-(IBAction)newPressed:(id)sender {
    [self resetGame];
}

-(IBAction)validate:(id)sender {
    UIAlertView * alert;
    if ([self.board validateBoard]){
        alert = [[UIAlertView alloc] initWithTitle:@"You won!" message:@"Congrats! You rocked it. Press okay to play again!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    } else {
        alert = [[UIAlertView alloc] initWithTitle:@":/" message:@"Better than being blown up by a bomb, but you still lost, sorry. Press okay to play again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    }
    [self resetGame];
    [alert show];
}


#pragma mark - UICollectionViewFlowLayout Delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self collectionViewCellSize];
}

#pragma mark - general helper functions

-(void)resetGame {
    NSInteger boardSize = self.boardSizeField.text.integerValue;
    NSInteger bombCount = self.bombCountField.text.integerValue;
    self.board = [[TTBoardModel alloc] initWithBoardSize:boardSize andBombCount:bombCount];
    [self.collectionView reloadData];
}

-(CGSize)collectionViewCellSize {
    // we want squares the board to match the size of the screen, this makes it so that the size of the squares relates to the size of the board
    // the minus self.board.boardSize is to offset the slight spacing between rows defined in the storyBoard
    CGFloat edgesLength = (self.view.frame.size.width - self.board.boardSize) / self.board.boardSize;
    return CGSizeMake(edgesLength, edgesLength);
}

#pragma mark - lazy instantiation

-(UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture){
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
    }
    return _tapGesture;
}

-(TTBoardModel *)board {
    if (!_board){
        _board = [[TTBoardModel alloc] init];
    }
    return _board;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
