//
//  Util.m
//
//  Created by admin on 23/12/14.
//

#import "Util.h"
#import <FacebookSDK/FacebookSDK.h>
#import "UIImageView+AFNetworking.h"
#import "AFNetworking/AFImageRequestOperation.h"
#import "AFNetworking/AFHTTPClient.h"
#import "LoadingView.h"

@implementation Util

+(NSArray *)retreiveFBPermissions{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"FBPermissions"];
}

+(void)showMessage:(NSString *)alertText
         withTitle:(NSString *)title{
    [[[UIAlertView alloc] initWithTitle:title
                                message:alertText
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

+ (NSURLRequest *)createPutRequestFor:(NSString *)relativeURL
                           withParams:(NSString *)postString{
    return [self createRequestForMethod:@"PUT" forRelativeURL:relativeURL withParams:postString];
}

+ (NSURLRequest *)createPostRequestFor:(NSString *)relativeURL
                            withParams:(NSString *)postString{
    return [self createRequestForMethod:@"POST" forRelativeURL:relativeURL withParams:postString];
}

+ (NSURLRequest *)createRequestForMethod: (NSString *)method
                          forRelativeURL: (NSString *)relativeURL
                              withParams:(NSString *)paramString{
    NSString *serverURL = @"http://beaglest.nextmp.net";
    NSString *URL = [NSString stringWithFormat:@"%@/%@",
                     serverURL,
                     relativeURL];
    NSURL *aUrl = [NSURL URLWithString:URL];
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:aUrl
                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                    timeoutInterval:15.0];
    [request setHTTPMethod:method];
    [request setHTTPBody:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}


+ (NSURLRequest *)createGetRequestFor:(NSString *)absoluteURL
                           withParams:(NSString *)queryParams{
    NSString *URL = nil;
    if (queryParams)
        URL = [NSString stringWithFormat:@"%@?%@",
               absoluteURL,
               [queryParams stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    else
        URL = absoluteURL;
    NSURL *aUrl = [NSURL URLWithString:URL];
    NSURLRequest *request = [NSMutableURLRequest
                             requestWithURL:aUrl
                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                             timeoutInterval:15.0];
    return request;
}

+(void)addDefaultShadow:(UIView *)view{
    view.layer.shadowColor = [[UIColor blackColor] CGColor];
    view.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    view.layer.shadowOpacity = 0.5f;
    view.layer.shadowRadius = 0.25f;
}

+(UIView *)addBlurViewFor:(UIView *)parentView
                    above:(UIView *)sibling{
    UIToolbar* bgToolbar = [[UIToolbar alloc] init];
    bgToolbar.barStyle = UIBarStyleBlack;
    [bgToolbar setTranslucent:TRUE];
    [bgToolbar setTranslatesAutoresizingMaskIntoConstraints:false];
    if (sibling)
        [parentView insertSubview:bgToolbar
                     aboveSubview:sibling];
    else
        [parentView insertSubview:bgToolbar
                          atIndex:0];
    NSDictionary *bindings = NSDictionaryOfVariableBindings(bgToolbar);
    NSArray *horiConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bgToolbar]|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:bindings];
    NSArray *vertConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[bgToolbar]|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:bindings];
    [parentView addConstraints:horiConstraints];
    [parentView addConstraints:vertConstraints];
    return bgToolbar;
}

+(float)lerpFor:(float)x
         withX0:(float)x0
          andY0:(float)y0
          andX1:(float)x1
          andY1:(float)y1{
    return y0 + ((y1 - y0) * ((x - x0) / (x1 - x0)));
}

+(UIViewController *)loadViewController:(NSString *)identifier{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    UIViewController *retVal = [storyBoard instantiateViewControllerWithIdentifier:identifier];
    return retVal;
}

+(NSObject *)getUserID{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
}

+(UIView *)loadViewWithNibName:(NSString *)nibName
                       andType:(Class)type{
    UIView *dialog = nil;
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    for (id oneObject in nib)
        if ([oneObject isKindOfClass:[type class]]){
            dialog = (UIView *)oneObject;
        }
    return dialog;
}

+(NSString *)convertUnixTSToDate:(float)timeStamp{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setLocale:[NSLocale currentLocale]];
    [dateformatter setDateFormat:@"dd-MM-yyyy"];
    return [dateformatter stringFromDate:date];
}

+(NSString *)fbErrorFrom:(NSError *)error{
    if ([FBErrorUtility shouldNotifyUserForError:error] == YES)
        return [FBErrorUtility userMessageForError:error];
    else {
        if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled)
            return @"This facebook action is necessary to get the full U100 experience";
        else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession)
            return @"Your current session is no longer valid. Please log out and log in again.";
        else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession)
            return @"Your current session is no longer valid. Please log in again.";
        else
            return @"Something seems to have gone wrong, please retry";
    }
}

+(UIViewController *)findContainingControllerFor:(UIView *) view{
    if ([[view nextResponder] isKindOfClass:[UIViewController class]])
        return (UIViewController *) [view nextResponder];
    return [self findContainingControllerFor:[view superview]];
}

+(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+(int)getCountFor:(NSArray *)list
               at:(NSInteger)section
             with:(int)numCols{
    int numRows = (int) [list count] / numCols;
    int remainder = [list count] % numCols;
    if (section < remainder) {
        numRows += 1;
    }
    return numRows;
}

+(int)getColIndexFor:(NSArray *)list
                  at:(NSIndexPath *)indexPath
                with:(int)numCols{
    return (int)(indexPath.row * numCols) + (int)indexPath.section;
}

+(NSIndexPath *)getIndexPathForIdx:(int)i
                        andNumCols:(int)numCols{
    int row = i / numCols;
    int section = (int) !((i % 2) == 0);
    return [NSIndexPath indexPathForRow:row
                              inSection:section];
}

+(void)extractChildCategoriesFrom:(NSArray *)children
                                  into:(NSMutableArray *)categories{
    if (children && [children count] > 0) {
        for (NSDictionary *child in children) {
            NSInteger level = [[child valueForKey:@"level"] integerValue];
            if (level == 2)
                [categories addObject:child];
            if (level < 2)
                [self extractChildCategoriesFrom:[child objectForKey:@"children"]
                                            into:categories];
        }
    }
}

+(NSArray *)getHomeFeedCallParamsFor:(int)currPage{
    /*
    AppDelegate *ad = [[UIApplication sharedApplication] delegate];
    NSMutableArray *callParams = [[NSMutableArray alloc] init];
    NSArray *sortParams = [ad.searchParams objectForKey:@"SortParams"];
    NSString *selectedBrand = [ad.searchParams objectForKey:@"SelectedBrand"];
    if (!sortParams)
        sortParams = @[@"", @""];
    NSDictionary *category = [ad.searchParams objectForKey:@"SlectedCategory"];
    NSObject *selCat = [category objectForKey:@"category_id"];
    NSArray *catFilter = @[];
    if (selCat)
        catFilter = @[selCat];
    [callParams addObjectsFromArray:@[@"under.homefeed",
                                      [sortParams objectAtIndex:0],
                                      [sortParams objectAtIndex:1],
                                      [Util getUserID],
                                      catFilter,
                                      [NSNumber numberWithInt:currPage],
                                      @"20"]];
    if (selectedBrand) {
        NSDictionary *filters = @{ @"brand":@[selectedBrand],
                                   @"status":@"1"};
        [callParams addObject:filters];
    }
    return callParams;
     */
    return nil;
}

+(NSMutableDictionary *)getSearchParams{
    /*
    AppDelegate *ad = [[UIApplication sharedApplication] delegate];
    if (!ad.searchParams)
        ad.searchParams = [[NSMutableDictionary alloc] init];
    return ad.searchParams;
     */
    return nil;
}

+(void)loadProfilePicInfo:(FBProfilePictureView *)profilePicView{
    if (FBSession.activeSession.isOpen) {
        [FBRequestConnection
         startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                           id<FBGraphUser> user,
                                           NSError *error) {
             if (!error) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [profilePicView setProfileID:[user objectID]];
                     [profilePicView setPictureCropping:FBProfilePictureCroppingSquare];
                     profilePicView.layer.cornerRadius = CGRectGetWidth(profilePicView.frame) / 2.0;
                 });
             }
         }];
    }
}

+(void)loadBrandImageFor:(NSDictionary *)productDetails
                    into:(UIImageView *)brandImage{
    
}

+(UIColor *)appOrangeColor{
    return [self colorWithHexString:@"E24030"];
}

+(int)myFeedBtnTag{
    return 2323;
}

+(NSString *)getDateText:(NSTimeInterval)interval{
    NSNumber *numHours = [NSNumber numberWithInt:(int) (- interval / (60.0 * 60.0))];
    NSNumber *numDays = [NSNumber numberWithInt:[numHours intValue] / 24];
    NSNumber *numWeeks = [NSNumber numberWithInt:[numDays intValue] / 7];
    NSNumber *numYears = [NSNumber numberWithInt:[numWeeks intValue] / 52];
    NSArray *priority = @[numYears, numWeeks, numDays, numHours];
    NSArray *format = @[@"y", @"w", @"d", @"h"];
    NSString *retVal = @"";
    for (int i = 0; i < [priority count]; i++) {
        int num = [[priority objectAtIndex:i] intValue];
        if (num > 0){
            retVal = [NSString stringWithFormat:@"%d %@ ago", num, [format objectAtIndex:i]];
            break;
        }
    }
    if ([retVal length] == 0) {
        retVal = @"0 h ago";
    }
    return retVal;
}

+(void)showView:(UIView *)childView
         inside:(UIView *)parentView{
    [childView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [parentView addSubview:childView];
    NSDictionary *bindings = NSDictionaryOfVariableBindings(childView);
    NSArray *vertConstraints = [NSLayoutConstraint
                                constraintsWithVisualFormat:@"V:|[childView]|"
                                options:0
                                metrics:nil
                                views:bindings];
    [parentView addConstraints:vertConstraints];
    [parentView addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|[childView]|"
                               options:0
                               metrics:nil
                               views:bindings]];
}

+(void)postToPath:(NSString *)relativePath
           params:(NSDictionary *)params{
    
}

+(BOOL)validateEmail:(NSString *)candidate{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

+(LoadingView *)showLoadingViewOver:(UIView *)view
                               with:(NSString *)status{
    LoadingView *loadingView = (LoadingView *) [Util loadViewWithNibName:@"LoadingView"
                                                    andType:[LoadingView class]];
    [Util showView:loadingView
            inside:view];
    [loadingView.status setText:status];
    [loadingView.progressView startAnimating];
    return loadingView;
}
@end
