//
//  KKCollectionViewCellProtocol.h
//  kindergartenApp
//
//  Created by 尤彬 on 2018/10/25.
//  Copyright © 2018 youbin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KKCollectionViewCellProtocol <NSObject>

@optional

- (void) kk_setupView;

- (void) KK_bindViewModel;

@end
