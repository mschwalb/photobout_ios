//
//  ListsCell.h
//
//  Created by admin on 17/02/15.
//

#import <UIKit/UIKit.h>

@interface ListsCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet UIImageView *photo;
@property (nonatomic, strong) IBOutlet UIImageView *addList;

-(void)populateWith:(NSDictionary *)productDetails;
-(void)showAddView;

@end
