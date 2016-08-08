//
//  Util.h
//
//  Created by admin on 23/12/14.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "SingleProductViewDelegate.h"
#import "SingleProductView.h"

@interface Util : NSObject

+(NSArray *)retreiveFBPermissions;
+(void)showMessage:(NSString *)alertText
         withTitle:(NSString *)title;
+(NSURLRequest *)createGetRequestFor:(NSString *)relativeURL
                          withParams:(NSString *)queryParams;
+(void)addDefaultShadow:(UIView *)view;
+(UIView *)addBlurViewFor:(UIView *)parentView
                    above:(UIView *)sibling;
+(float)lerpFor:(float)x
         withX0:(float)x0
          andY0:(float)y0
          andX1:(float)x1
          andY1:(float)y1;
+(UIViewController *)loadViewController:(NSString *)identifier;
+ (NSURLRequest *)createRequestForMethod: (NSString *)method
                          forRelativeURL: (NSString *)relativeURL
                              withParams:(NSString *)paramString;
+ (NSURLRequest *)createPostRequestFor:(NSString *)relativeURL
                            withParams:(NSString *)postString;
+ (NSURLRequest *)createPutRequestFor:(NSString *)relativeURL
                           withParams:(NSString *)postString;
+(NSObject *)getUserID;
+(UIView *)loadViewWithNibName:(NSString *)nibName
                       andType:(Class)type;
+(NSString *)convertUnixTSToDate:(float)timeStamp;
+(NSString *)fbErrorFrom:(NSError *)error;
+(UIViewController *)findContainingControllerFor:(UIView *) view;
+(UIColor*)colorWithHexString:(NSString*)hex;
+(int)getCountFor:(NSArray *)list
               at:(NSInteger)section
             with:(int)numCols;
+(int)getColIndexFor:(NSArray *)list
                  at:(NSIndexPath *)indexPath
                with:(int)numCols;
+(NSIndexPath *)getIndexPathForIdx:(int)idx
                        andNumCols:(int)numCols;
+(void)extractChildCategoriesFrom:(NSArray *)children
                             into:(NSMutableArray *)categories;
+(NSArray *)getHomeFeedCallParamsFor:(int)currPage;
+(NSMutableDictionary *)getSearchParams;
+(void)loadProfilePicInfo:(FBProfilePictureView *)profilePicView;
+(void)loadBrandImageFor:(NSDictionary *)productDetails
                    into:(UIImageView *)brandImage;
+(UIColor *)appOrangeColor;
+(int)myFeedBtnTag;
+(NSString *)getDateText:(NSTimeInterval)timeStmp;
+(void)showView:(UIView *)childView
         inside:(UIView *)parentView;
+(void)postToPath:(NSString *)relativePath
           params:(NSDictionary *)params;
+(BOOL)validateEmail:(NSString *)candidate;
+(LoadingView *)showLoadingViewOver:(UIView *)view
                               with:(NSString *)status;

@end
