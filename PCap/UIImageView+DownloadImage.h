//
//  UIImageView+DownloadImage.h
//  PCap
//
//  Created by Kasey Baughan on 6/15/17.
//  Copyright © 2017 Kasey Baughan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (DownloadImage)

- (void) downloadAndSetImage: (NSString *) urlString;
- (void) downloadImage: (NSString *) urlString
              callback: (void (^)(UIImage *image))callback;

@end
