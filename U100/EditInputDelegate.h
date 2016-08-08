//
//  EditInputDelegate.h
//
//  Created by admin on 09/03/15.
//

#import <Foundation/Foundation.h>

@protocol EditInputDelegate <NSObject>

-(void)valueEntered:(NSString *)input
             forKey:(NSString *)paramKey;

@end