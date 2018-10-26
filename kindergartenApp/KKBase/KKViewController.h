//
//  KKViewController.h
//  kindergartenApp
//
//  Created by 尤彬 on 2018/10/25.
//  Copyright © 2018 youbin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKViewControllerProtocol.h"
#import "KKNavigationController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKViewController : UIViewController<KKViewControllerProtocol,
                                               UIScrollViewDelegate,
                                               UITableViewDelegate,
                                               UITableViewDataSource,
                                               UICollectionViewDelegate,
                                               UICollectionViewDataSource,
                                               UICollectionViewDelegateFlowLayout,
                                               DZNEmptyDataSetSource,
                                               DZNEmptyDataSetDelegate>

@property (nonatomic,strong) UITableView      * plainTableView;
@property (nonatomic,strong) UITableView      * groupTableView;
@property (nonatomic,strong) UICollectionView * listCollectionView;
@property (nonatomic,strong) NSMutableArray   * dataSources;

@end

NS_ASSUME_NONNULL_END
