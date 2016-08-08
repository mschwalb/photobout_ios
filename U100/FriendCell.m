//
//  FriendCell.m
//
//  Created by admin on 20/04/15.
//

#import "FriendCell.h"

@implementation FriendCell

-(void)populate:(NSDictionary *)usrDetails{
    userDetails = usrDetails;
    [_name setText:[usrDetails valueForKey:@"name"]];
    [_userImage populateProfilePicWith:[usrDetails valueForKey:@"profile_picture"]];
}

-(NSDictionary *)getUserDetails{
    return userDetails;
}

@end
