//
//  LoadingView.h
//
//  Created by admin on 22/03/15.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView

@property (nonatomic, strong) IBOutlet UILabel *status;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *progressView;

@end
