//
//  NetworkCell.h
//
//  Created by admin on 17/02/15.
//

#import <UIKit/UIKit.h>
#import "ProfilePicView.h"

@interface NetworkCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet ProfilePicView *profilePic;
@property (nonatomic, strong) IBOutlet UILabel *name;

-(void)populateWith:(NSDictionary *)productDetails;

@end
