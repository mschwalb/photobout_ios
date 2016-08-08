//
//  CommentCell.m
//
//  Created by admin on 28/01/15.
//

#import "CommentCell.h"
#import "Util.h"

@implementation CommentCell

-(void)populateWith:(NSDictionary *)_comment{
    comment = _comment;
    [self addUserProfileGestureRecogniser];
    NSString *name = [NSString stringWithFormat:@"%@ %@", [comment valueForKey:@"first_name"], [comment valueForKey:@"last_name"]];
    [_user setText:name];
    [_commentLabel setText:[comment valueForKey:@"message"]];
    [_timeLabel setText:[comment valueForKey:@"timestamp"]];
    [_profilePic populateProfilePicWith:[comment valueForKey:@"profile_picture"]];
}

-(void)addUserProfileGestureRecogniser{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(showUserProfile:)];
    [_profilePic addGestureRecognizer:tap];
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(showUserProfile:)];
    [_user addGestureRecognizer:tap];
}

-(void)showUserProfile:(UITapGestureRecognizer *)tap{
    NSDictionary *deets = @{@"user_id":[comment objectForKey:@"id"],
                            @"user_profile_pic":[comment valueForKey:@"profile_picture"],
                            @"user_name":[_user text],
                            @"user_fb_id":@""};
    [_delegate showUserProfile:deets];
}

@end
