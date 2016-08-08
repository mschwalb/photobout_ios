//
//  LeaderBoardCell.m
//
//  Created by admin on 02/04/15.
//

#import "LeaderBoardCell.h"

@implementation LeaderBoardCell

-(void)populateWith:(NSDictionary *)deets{
    [_handle setText:[deets valueForKey:@"email"]];
    [self loadName:deets];
    [_numVotes setText:[NSString stringWithFormat:@"%@ vote(s)", [deets objectForKey:@"votes"]]];
    //[_rank setText:[NSString stringWithFormat:@"%@", [deets objectForKey:@"rank"]]];
    [_rank setHidden:true];
    [self populateProfilePic:deets];
}

-(void)loadName:(NSDictionary *)deets{
    NSString *name = [NSString stringWithFormat:@"%@ %@", [deets valueForKey:@"first_name"], [deets valueForKey:@"last_name"]];
    [_name setText:name];
}

-(void)populateProfilePic:(NSDictionary *)deets{
    [_profilePic populateProfilePicWith:[deets valueForKey:@"profile_picture"]];
}

@end
