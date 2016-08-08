//
//  FriendCell.h
//
//  Created by admin on 20/04/15.
//

#import <UIKit/UIKit.h>
#import "ProfilePicView.h"

@interface FriendCell : UITableViewCell{
    @private
    NSDictionary *userDetails;
}

@property (nonatomic, weak) IBOutlet ProfilePicView *userImage;
@property (nonatomic, weak) IBOutlet UIImageView *checkImg;
@property (nonatomic, weak) IBOutlet UILabel *name;

-(void)populate:(NSDictionary *)usrDetails;
-(NSDictionary *)getUserDetails;

@end
