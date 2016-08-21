//
//  UIImageView+PDKNetworkUtilities.m
//  PinterestSDK
//
//  Created by Tim Johnsen on 8/21/16.
//  Copyright © 2016 ricky cancro. All rights reserved.
//

#import "UIImageView+PDKNetworkUtilities.h"

#import <objc/runtime.h>

static const char *kUIImageViewPDKNetworkUtilitiesImageURLKey = "kUIImageViewPDKNetworkUtilitiesImageURLKey";

@implementation UIImageView (PDKNetworkUtilities)

- (void)setImageWithURL:(NSURL *const)url
{
    objc_setAssociatedObject(self, kUIImageViewPDKNetworkUtilitiesImageURLKey, url, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    if (url) {
        [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSURL *const currentURL = objc_getAssociatedObject(self, kUIImageViewPDKNetworkUtilitiesImageURLKey);
            if ([currentURL isEqual:url]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.image = [UIImage imageWithData:data];
                });
            }
        }] resume];
    } else {
        self.image = nil;
    }
}

@end
