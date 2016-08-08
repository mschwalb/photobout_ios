//
//  TagFollowerCell.h
//
//  Created by admin on 24/02/15.
//

#import <UIKit/UIKit.h>
#import "ProfilePicView.h"

@interface TagFollowerCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet ProfilePicView *profilePic;

-(void)populateWith:(NSDictionary *)follower;

@end
