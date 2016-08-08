//
//  SingleProductView.h
//
//  Created by admin on 18/02/15.
//

#import <UIKit/UIKit.h>
#import "SingleProductViewDelegate.h"
#import "ProductContainer.h"
#import "BoutView.h"

@interface SingleProductView : UIView<ProductContainer>{
    @private
    BoutView *bv;
}

@property (nonatomic, strong) IBOutlet UIButton *close;
@property (nonatomic, assign) id<SingleProductViewDelegate> delegate;

-(void)populateWithID:(NSObject *)prodID;
-(void)populateWith:(NSDictionary *)productDetails;
-(IBAction)closePressed:(id)sender;

@end
