//
//  EmailButton.m
//
//  Created by admin on 11/02/15.
//

#import "EmailButton.h"
#import "Util.h"

@implementation EmailButton

-(void)share:(NSDictionary *)productDetails{
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:[NSString stringWithFormat:@"You have to check out %@", [productDetails valueForKey:@"name"]]];
    [controller setMessageBody:[NSString stringWithFormat:@"You can read more about it here: %@", [productDetails valueForKey:@"product_origin_url"]]
                        isHTML:NO];
    UIViewController *parent = [Util findContainingControllerFor:self];
    if (controller)
        [parent presentViewController:controller
                             animated:YES
                           completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent)
        [Util showMessage:@"Email successsfully sent"
                withTitle:@"Success"];
    UIViewController *parent = [Util findContainingControllerFor:self];
    [parent dismissViewControllerAnimated:YES
                               completion:nil];
}

@end
