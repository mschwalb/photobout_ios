//
//  ActivityCell.m
//
//  Created by admin on 05/02/15.
//

#import "ActivityCell.h"
#import "Util.h"

@implementation ActivityCell

-(void)populateWith:(NSAttributedString *)message
                and:(NSString *)time
                and:(NSString *)userID{
    [_message setAttributedText:message];
    [_time setText:time];
    [_profilePic populateProfilePicWith:userID];
}

@end
