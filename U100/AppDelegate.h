//
//  AppDelegate.h
//  U100
//
//  Created by Marko Bulaić on 21/08/14.
//  Copyright (c) 2014 Gauss Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIAlertView *alert;
@property (strong, nonatomic) NSMutableDictionary *searchParams;
@property (strong, nonatomic) NSString *deviceTokenHex;
@property (strong, nonatomic) NSString *notifBoutID;

-(void)removeFromView;

@end
