//
//  EmailButton.h
//
//  Created by admin on 11/02/15.
//

#import "ShareButton.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface EmailButton : ShareButton<MFMailComposeViewControllerDelegate>

@end
