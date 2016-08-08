//
//  BoutDurationView.h
//
//  Created by admin on 14/04/15.
//

#import <UIKit/UIKit.h>
#import "BoutDurationDelegate.h"

@interface BoutDurationView : UIView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) id<BoutDurationDelegate> delegate;

@end
