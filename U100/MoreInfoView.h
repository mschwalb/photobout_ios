//
//  MoreInfoView.h
//
//  Created by admin on 10/02/15.
//

#import <UIKit/UIKit.h>
#import "MoreInfoContainer.h"

@interface MoreInfoView : UIView<UIActionSheetDelegate>{
    @private
    NSDictionary *productDetails;
}

-(void)populate:(NSDictionary *)productDetails;
-(IBAction)share:(id)sender;

@property (nonatomic, assign) id<MoreInfoContainer> delegate;
@property (nonatomic, assign) IBOutlet UILabel *name;
@property (nonatomic, assign) IBOutlet UILabel *desc;

@end
