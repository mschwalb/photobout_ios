//
//  UserResultsCell.h
//
//  Created by admin on 27/02/15.
//

#import <UIKit/UIKit.h>
#import "ProfilePicView.h"

@interface UserResultsCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet UILabel *followersLabel;
@property (nonatomic, strong) IBOutlet UILabel *followingLabel;
@property (nonatomic, strong) IBOutlet ProfilePicView *profilePic;
-(void)populate:(NSDictionary *)searchResults;

@end
