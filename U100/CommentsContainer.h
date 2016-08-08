//
//  CommentsContainer.h
//
//  Created by admin on 09/02/15.
//

@protocol CommentsContainer <NSObject>

-(void)closePressed;
-(void)updateCommentsCountTo:(int)count
                         for:(int)photoIdx;
-(void)showCommentUser:(NSObject *)uid;

@end
