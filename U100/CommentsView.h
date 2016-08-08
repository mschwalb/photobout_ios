//
//  CommentsView.h
//
//  Created by admin on 09/02/15.
//

#define COMMENTS_TABLE 23
#define FOLLOWERS_TABLE 24

#import <UIKit/UIKit.h>
#import "CommentsContainer.h"
#import "CommentCellDelegate.h"

@interface CommentsView : UIView<UITableViewDataSource, UITableViewDelegate, CommentCellDelegate>{
    @private
    NSMutableArray *comments;
    NSDictionary *productDetails;
    float origConstraint;
    int photoIdx;
    NSString *next;
}

@property (nonatomic, assign) id<CommentsContainer> delegate;

@property (nonatomic, strong) IBOutlet UITableView *commentsTable;
@property (nonatomic, strong) IBOutlet UIButton *commentBtn;
@property (nonatomic, strong) IBOutlet UITextField *commentInput;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *bottomConstraint;

-(void)populateComments:(NSDictionary *)productDetails
                    for:(int)idx;
-(IBAction)close:(id)sender;
-(IBAction)postComment:(id)sender;

@end
