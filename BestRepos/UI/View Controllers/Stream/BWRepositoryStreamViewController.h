//
//  BWRootViewController.h
//  BestRepos
//
//  Created by Kamran Pirwani on 6/1/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * @class BWRepositoryStreamViewController
 * @brief The view controller fetches and displayed the top 100 repositories on launch
 * @note The functionality to search via a variety of filters is also available, so we can search for any repository on GitHub
 */
@interface BWRepositoryStreamViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end
