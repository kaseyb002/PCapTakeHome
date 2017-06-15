//
//  UIImageView+DownloadImage.m
//  PCap
//
//  Created by Kasey Baughan on 6/15/17.
//  Copyright © 2017 Kasey Baughan. All rights reserved.
//

#import "UIImageView+DownloadImage.h"

@implementation UIImageView (DownloadImage)

- (void) downloadAndSetImage: (NSString *) urlString {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage* image = [[UIImage alloc]initWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setImage:image];
        });
    });
    
    
}

- (void) downloadImage: (NSString *) urlString
              callback: (void (^)(UIImage *image))callback {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage* image = [[UIImage alloc]initWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(image);
        });
    });
    
    
}

@end
