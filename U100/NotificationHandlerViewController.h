//
//  NotificationHandlerViewController.h
//
//  Created by admin on 25/05/15.
//

#import <UIKit/UIKit.h>
#import "SingleProductViewDelegate.h"

@interface NotificationHandlerViewController : UIViewController<SingleProductViewDelegate>

@property (nonatomic, assign) NSObject *boutID;

@end
