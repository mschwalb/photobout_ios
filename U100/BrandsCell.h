//
//  BrandsCell.h
//
//  Created by admin on 02/03/15.
//

#import <UIKit/UIKit.h>

@interface BrandsCell : UICollectionViewCell{
    @private
    NSDictionary *brandDetails;
}

-(void)populateWith:(NSDictionary *)brandDetails;

@property (nonatomic, strong) IBOutlet UIImageView *photo;
@property (nonatomic, strong) IBOutlet UILabel *name;

@end
