//
//  ProfilePicView.h
//
//  Created by admin on 04/03/15.
//

#import <UIKit/UIKit.h>

@interface ProfilePicView : UIView

-(void)populateProfilePicWith:(NSString *)imgURL;
-(void)populateProfilePicForLoggedInUser;
-(void)clearImage;

@end
