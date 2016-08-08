//
//  TagFollowerCell.m
//
//  Created by admin on 24/02/15.
//

#import "TagFollowerCell.h"

@implementation TagFollowerCell

-(void)populateWith:(NSDictionary *)follower{
    [_name setText:[follower objectForKey:@"name"]];
    //[_profilePic populateProfilePicFor:[follower objectForKey:@"uid"]];
}

@end
