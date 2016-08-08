//
//  ProductDetailsView.h
//
//  Created by admin on 06/01/15.
//

#import <UIKit/UIKit.h>
#import "ProductContainer.h"
#import "ProductDetailsContainer.h"

#define COMMENTS_TABLE_TAG 1
#define LISTS_TABLE_TAG 2

@interface ProductDetailsView : UIView{
    @private
    NSDictionary *productDetails;
    NSString *cartID;
    NSMutableArray *comments;
    NSMutableArray *lists;
}

@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet UILabel *user;
@property (nonatomic, strong) IBOutlet UILabel *brand;
@property (nonatomic, strong) IBOutlet UILabel *price;
@property (nonatomic, strong) IBOutlet UIButton *comment;
@property (nonatomic, strong) IBOutlet UIButton *like;
@property (nonatomic, strong) IBOutlet UIView *buyContainer;
@property (nonatomic, assign) id<ProductDetailsContainer> delegate;

-(void)populate:(NSDictionary *)productDetails;
-(IBAction)showComments:(id)sender;
-(IBAction)showMoreInfo:(id)sender;

@end
