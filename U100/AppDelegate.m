//
//  AppDelegate.m
//  U100
//
//  Created by Marko Bulaić on 21/08/14.
//  Copyright (c) 2014 Gauss Development. All rights reserved.
//

#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Flurry.h"
#import "SingleProductView.h"
#import "Util.h"

#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
@interface AppDelegate ()

@end
@implementation AppDelegate

//NSString * const StripePublishableKey = @"pk_test_6pRNASCoBOKtIshFeQd4XMUh";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Flurry setCrashReportingEnabled:true];
    [Flurry startSession:@"J5B5G5F7FXWXDC9MCQFX"];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [application registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    if(launchOptions){
        NSDictionary *dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        NSDictionary *data = [dictionary objectForKey:@"aps"];
        [UIApplication sharedApplication].applicationIconBadgeNumber += [[data objectForKey: @"badgecount"] intValue];
        _notifBoutID = [dictionary objectForKey:@"bid"];
    }
    return YES;
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBAppCall handleDidBecomeActive];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
   return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

-(void)removeFromView{
   
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSDictionary *data = [userInfo objectForKey:@"aps"];
    if (data && [data valueForKey:@"alert"] &&
        application.applicationState != UIApplicationStateActive){
        [UIApplication sharedApplication].applicationIconBadgeNumber += [[data objectForKey: @"badgecount"] intValue];
        UIViewController *vc = _window.rootViewController.presentedViewController;
        [vc performSegueWithIdentifier:@"notificationHandlerViewController"
                                sender:[userInfo objectForKey:@"bid"]];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken: (NSData *)deviceToken
{
    _deviceTokenHex = [NSString stringWithFormat:@"%@", deviceToken];
    _deviceTokenHex = [_deviceTokenHex stringByReplacingOccurrencesOfString:@"<"
                                                                 withString:@""];
    _deviceTokenHex = [_deviceTokenHex stringByReplacingOccurrencesOfString:@">"
                                                                 withString:@""];
    _deviceTokenHex = [_deviceTokenHex stringByReplacingOccurrencesOfString:@" "
                                                                 withString:@""];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError: (NSError*)error{
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:[error localizedDescription]
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

@end
