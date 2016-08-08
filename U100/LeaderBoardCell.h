//
//  LeaderBoardCell.h
//
//  Created by admin on 02/04/15.
//

#import <UIKit/UIKit.h>
#import "ProfilePicView.h"

@interface LeaderBoardCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet UILabel *handle;
@property (nonatomic, strong) IBOutlet UILabel *numVotes;
@property (nonatomic, strong) IBOutlet UILabel *rank;
@property (nonatomic, strong) IBOutlet ProfilePicView *profilePic;

-(void)populateWith:(NSDictionary *)deets;

@end
