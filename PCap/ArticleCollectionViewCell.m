//
//  ArticleCollectionViewCell.m
//  PCap
//
//  Created by Kasey Baughan on 6/15/17.
//  Copyright © 2017 Kasey Baughan. All rights reserved.
//

#import "ArticleCollectionViewCell.h"
#import "UIImageView+DownloadImage.h"

@interface ArticleCollectionViewCell ()

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *titleLabel;

@end

@implementation ArticleCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //add title label
        CGRect titleFrame = CGRectMake(5,
                                       frame.size.height - 40,
                                       frame.size.width - 10,
                                       40);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame: titleFrame];
        titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:14.0];
        titleLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        titleLabel.numberOfLines = 2;
        self.titleLabel = titleLabel;
        [self addSubview: titleLabel];
        //add image view
        UIImage *placeholderImage = [UIImage imageNamed:@"pcap.png"];
        CGRect imageFrame = CGRectMake(0,
                                       0, 
                                       frame.size.width,
                                       frame.size.height
                                       - titleLabel.frame.size.height
                                       - 5);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
        imageView.contentMode = UIViewContentModeScaleToFill;//TODO: fix this
        imageView.layer.borderWidth = 1.0;
        imageView.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1.0] CGColor];
        self.imageView = imageView;
        [imageView setImage:placeholderImage];
        [self addSubview:imageView];
        //add gray border
        self.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1.0] CGColor];
        self.layer.borderWidth = 1.0;
    }
    
    return self;
}

- (void)updateCellWithArticle: (Article *) article; {
    self.titleLabel.text = article.title;
    [self.imageView downloadAndSetImage:article.imageUrl];
}

+ (NSString *)reuseId {
    return @"articleCell";
}

@end
