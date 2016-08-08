//
//  NetworkCell.m
//
//  Created by admin on 17/02/15.
//

#import "NetworkCell.h"
#import "Util.h"

@implementation NetworkCell

-(void)populateWith:(NSDictionary *)userDeets{
    [_name setText:[userDeets valueForKey:@"name"]];
    [_profilePic populateProfilePicWith:[userDeets valueForKey:@"profile_picture"]];
}

-(void)prepareForReuse{
    [_profilePic clearImage];
}

@end
