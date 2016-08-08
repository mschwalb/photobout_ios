//
//  CommentCell.h
//
//  Created by admin on 28/01/15.
//

#import <UIKit/UIKit.h>
#import "ProfilePicView.h"
#import "CommentCellDelegate.h"

@interface CommentCell : UITableViewCell{
    @private
    NSDictionary *comment;
}

-(void)populateWith:(NSDictionary *)comment;

@property (nonatomic, strong) IBOutlet UILabel *user;
@property (nonatomic, strong) IBOutlet UILabel *commentLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet ProfilePicView *profilePic;
@property (nonatomic, assign) id<CommentCellDelegate> delegate;

@end
