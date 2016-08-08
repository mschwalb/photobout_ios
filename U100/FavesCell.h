//
//  FavesCell.h
//
//  Created by admin on 17/02/15.
//

#import <UIKit/UIKit.h>

@interface FavesCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIImageView *image;
-(void)populateWith:(NSDictionary *)productDetails;

@end
