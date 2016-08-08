//
//  SmallFeedCell.h
//
//  Created by admin on 29/12/14.
//

#import <UIKit/UIKit.h>

@interface SmallFeedCell : UICollectionViewCell{
    @private
    NSDictionary *boutsDetails;
}

@property (nonatomic, strong) IBOutlet UIImageView *photo;
@property (nonatomic, strong) IBOutlet UIImageView *icon;
@property (nonatomic, strong) IBOutlet UIImageView *winnerBookmark;
@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet UILabel *countLabel;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *widthConstraint;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, assign) BOOL isBout;

-(void)setDetails:(NSDictionary *)productDetails;
-(void)populate;
-(void)clearView;
-(NSDictionary *)getProductDetails;

@end
