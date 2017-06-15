//
//  ViewController.h
//  PCap
//
//  Created by Kasey Baughan on 6/14/17.
//  Copyright © 2017 Kasey Baughan. All rights reserved.
//

#import <UIKit/UIKit.h>
/*!
 @class ViewController
 
 @brief Displays a collection view of the most recent articles from Personal Capital blog.
 
 */

@interface ViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    UICollectionView *collectionView;
}
@end

