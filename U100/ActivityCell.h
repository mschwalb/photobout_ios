//
//  ActivityCell.h
//
//  Created by admin on 05/02/15.
//

#import <UIKit/UIKit.h>
#import "ProfilePicView.h"

@interface ActivityCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *message;
@property (nonatomic, strong) IBOutlet UILabel *time;
@property (nonatomic, strong) IBOutlet ProfilePicView *profilePic;

-(void)populateWith:(NSAttributedString *)message
                and:(NSString *)time
                and:(NSString *)userID;

@end
