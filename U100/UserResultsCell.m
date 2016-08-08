//
//  UserResultsCell.m
//
//  Created by admin on 27/02/15.
//

#import "UserResultsCell.h"
#import "Util.h"

@implementation UserResultsCell

-(void)populate:(NSDictionary *)searchResult{
    [_name setText:[searchResult valueForKey:@"name"]];
    [_profilePic populateProfilePicWith:[searchResult valueForKey:@"profile_picture"]];
}

@end
