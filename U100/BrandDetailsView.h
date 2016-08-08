//
//  BrandDetailsView.h
//
//  Created by admin on 03/03/15.
//

#import <UIKit/UIKit.h>
#import "BrandDetailsContainer.h"

@interface BrandDetailsView : UIView{
    @private
    NSDictionary *brandDetails;
}

@property (nonatomic, assign) IBOutlet UILabel *name;
@property (nonatomic, assign) IBOutlet UITextView *descText;
@property (nonatomic, assign) IBOutlet UIImageView *photo;
@property (nonatomic, assign) IBOutlet UIButton *productsButton;
@property (nonatomic, assign) id<BrandDetailsContainer> delegate;

-(IBAction)closePressed:(id)sender;
-(IBAction)showBrandProducts:(id)sender;
-(void)populateWith:(NSDictionary *)brandDetails;

@end
