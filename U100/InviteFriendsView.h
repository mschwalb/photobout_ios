//
//  InviteFriendsView.h
//
//  Created by admin on 20/04/15.
//

#import <UIKit/UIKit.h>
#import "CreateBoutDelegate.h"
#import "ProfilePicView.h"

@interface InviteFriendsView : UIView<UITableViewDataSource, UITableViewDelegate>{
    @private
    NSArray *friends;
    NSMutableDictionary *selectedCells;
    BOOL areAllSelected;
}

@property (nonatomic, strong) IBOutlet ProfilePicView *profilePic;
@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet UIImageView *selectAllImg;
@property (nonatomic, strong) IBOutlet UILabel *numFriends;
@property (nonatomic, strong) IBOutlet UIView *container;
@property (nonatomic, strong) IBOutlet UITableView *friendsTable;
@property (nonatomic, assign) id<CreateBoutDelegate> delegate;

-(void)populate;
-(IBAction)nextPressed:(id)sender;

@end
