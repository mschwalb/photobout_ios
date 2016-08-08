//
//  UIImageView+Network.m
//
//  Created by Soroush Khanlou on 8/25/12.
//
//

#import "UIImageView+Network.h"
#import "FTWCache.h"
#import <objc/runtime.h>

static char URL_KEY;


@implementation UIImageView(Network)

@dynamic imageURL;

- (void) loadImageFromURL:(NSURL*)url placeholderImage:(UIImage*)placeholder cachingKey:(NSString*)key index:(id)indexPath; {
	self.imageURL = url;
	self.image = placeholder;
    NSMutableArray *imagesArray=[[NSMutableArray alloc] init];
	NSData *cachedData = [FTWCache objectForKey:key];
	if (cachedData) {   
 	   self.imageURL   = nil;
 	   self.image      = [UIImage imageWithData:cachedData];
	   return;
	}

	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
	dispatch_async(queue, ^{
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
                                                    cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                timeoutInterval:30];
        NSData *urlData;
        NSURLResponse *response;
        NSError *error;
        
        urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                        returningResponse:&response
                                                    error:&error];
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:urlData
                                                                   options:kNilOptions
                                                                     error:&error];

        if (![[dictionary valueForKey:@"url"] isKindOfClass:[NSString class]]){
            
            NSArray *tempArray = [dictionary valueForKey:@"url"];
            
            for (int i = 0; i < tempArray.count; i++) {
                NSString *decodedString = [[[dictionary valueForKey:@"url"] objectAtIndex:i] stringByRemovingPercentEncoding];
                
                NSURL *url2 = [NSURL URLWithString:decodedString];
                
                NSData *imageData = [[NSData alloc] initWithContentsOfURL:url2];
                
                UIImage *imageFromData = [UIImage imageWithData:imageData];
               // [imagesArray addObject:imageFromData];

                [FTWCache setObject:imageData forKey:key];
                
                if (imageFromData) {
                    if ([self.imageURL.absoluteString isEqualToString:url.absoluteString]) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            self.image = imageFromData;
                                                    [imagesArray addObject:imageFromData];
                            if(tempArray.count>1){
                                if(i==0) [[NSNotificationCenter defaultCenter] postNotificationName: @"imageReady" object: indexPath];

                            if(i==tempArray.count-1){
                                NSString *key3 = [NSString stringWithFormat:@"5-%@",key];

                                NSData *data2 = [NSKeyedArchiver archivedDataWithRootObject:imagesArray];
                                [FTWCache setObject:data2 forKey:key3];
                                [[NSNotificationCenter defaultCenter] postNotificationName: @"arrayReady" object: indexPath];

                            }}
                            else {
                                if(i==0) [[NSNotificationCenter defaultCenter] postNotificationName: @"imageReady" object: indexPath];
}
                        });
                    } else {
                    }
                }
            }
        }

        
		self.imageURL = nil;
	});
    
}


- (void) setImageURL:(NSURL *)newImageURL {
	objc_setAssociatedObject(self, &URL_KEY, newImageURL, OBJC_ASSOCIATION_COPY);
}

- (NSURL*) imageURL {
	return objc_getAssociatedObject(self, &URL_KEY);
}
- (void) loadImageFromURL1:(NSURL*)url placeholderImage:(UIImage*)placeholder cachingKey:(NSString*)key {
    self.imageURL = url;
    self.image = placeholder;
    
    NSData *cachedData = [FTWCache objectForKey:key];
    if (cachedData) {
        self.imageURL   = nil;
        self.image      = [UIImage imageWithData:cachedData];
        return;
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        UIImage *imageFromData = [UIImage imageWithData:data];
        
        [FTWCache setObject:data forKey:key];
        
        if (imageFromData) {
            if ([self.imageURL.absoluteString isEqualToString:url.absoluteString]) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    self.image = imageFromData;
                });
            } else {
            }
        }
        self.imageURL = nil;
    });
}
@end
