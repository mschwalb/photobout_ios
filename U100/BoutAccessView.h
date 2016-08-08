//
//  BoutAccessView.h
//
//  Created by admin on 12/05/15.
//

#import <UIKit/UIKit.h>
#import "BoutAccessDelegate.h"

@interface BoutAccessView : UIView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) id<BoutAccessDelegate> delegate;

@end