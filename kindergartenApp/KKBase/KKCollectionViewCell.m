//
//  KKCollectionViewCell.m
//  kindergartenApp
//
//  Created by 尤彬 on 2018/10/25.
//  Copyright © 2018 youbin. All rights reserved.
//

#import "KKCollectionViewCell.h"

@implementation KKCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self kk_setupView];
        [self KK_bindViewModel];
    }
    return self;
}


-(void)kk_setupView{}


-(void)KK_bindViewModel{}

@end
