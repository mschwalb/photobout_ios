//
//  FullScreenFeedDelegate.h
//
//  Created by admin on 28/01/15.
//

#import <Foundation/Foundation.h>

@protocol FullScreenFeedDelegate <NSObject>

-(void)showCommentsClicked;
-(void)closeCommentsClicked;
-(void)showMoreInfoClicked;
-(void)closeMoreInfoClicked;
-(void)updateVoteTo:(NSObject *)count;

@end