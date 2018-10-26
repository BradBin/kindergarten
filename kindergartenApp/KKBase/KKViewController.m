//
//  KKViewController.m
//  kindergartenApp
//
//  Created by 尤彬 on 2018/10/25.
//  Copyright © 2018 youbin. All rights reserved.
//

#import "KKViewController.h"

@interface KKViewController ()

@end

@implementation KKViewController

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    KKViewController *viewController = [super allocWithZone:zone];
    @weakify(viewController);
    [[viewController rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(viewController);
        [viewController kk_addSubviews];
        [viewController kk_bindViewModel];
        [viewController kk_layoutNavigation];
    }];
    
    [[viewController rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
        @strongify(viewController)
        [viewController kk_getNewData];
    }];
    return viewController;
}


-(instancetype)initWithViewModel:(id<KKViewModelProtocol>)viewModel{
    return [super init];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}




#pragma mark -initialize instance

-(UITableView *)plainTableView{
    if (_plainTableView == nil) {
        _plainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _plainTableView.delegate   = self;
        _plainTableView.dataSource = self;
        _plainTableView.emptyDataSetDelegate = self;
        _plainTableView.emptyDataSetSource   = self;
    }
    return _plainTableView;
}

-(UITableView *)groupTableView{
    if (_groupTableView == nil) {
        _groupTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _groupTableView.delegate   = self;
        _groupTableView.dataSource = self;
        _groupTableView.emptyDataSetDelegate = self;
        _groupTableView.emptyDataSetSource   = self;
    }
    return _groupTableView;
}


-(UICollectionView *)listCollectionView{
    if (_listCollectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        _listCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _listCollectionView.delegate = self;
        _listCollectionView.dataSource = self;
        _listCollectionView.emptyDataSetDelegate = self;
        _listCollectionView.emptyDataSetSource = self;
    }
    return _listCollectionView;
}



#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell_Id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0.0;
}




#pragma mark - UICollectionViewDelegate/UICollectionViewDataSource
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 0;
}
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *collectionCellId = @"collection.Cell.Id";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellId
                                                                    forIndexPath:indexPath];
    return cell;
}








#pragma mark - KKViewControllerProtocol

/**
 需要登录
 */
-(void)kk_needRelogin{}

/**
 创建并布局视图
 */
-(void)kk_addSubviews{}

/**
 绑定数据
 */
-(void)kk_bindViewModel{}

/**
 设置导航栏
 */
-(void)kk_layoutNavigation{}

/**
 初次获取数据
 */
-(void)kk_getNewData{}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
