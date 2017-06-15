//
//  UIImageView+DownloadImage.h
//  PCap
//
//  Created by Kasey Baughan on 6/15/17.
//  Copyright © 2017 Kasey Baughan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (DownloadImage)

/*!@brief Downloads image from URL and sets it in ImageView.*/
- (void) downloadAndSetImage: (NSString *) urlString;
/*!@brief Downloads image from URL and provides custom callback with image.*/
- (void) downloadImage: (NSString *) urlString
              callback: (void (^)(UIImage *image))callback;

@end
