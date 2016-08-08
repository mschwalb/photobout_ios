//
//  ParentCatPickerDelegate.h
//
//  Created by admin on 22/03/15.
//

#import <Foundation/Foundation.h>

@protocol ParentCatPickerDelegate <NSObject>

-(void)categorySelected:(NSDictionary *)category;

@end
