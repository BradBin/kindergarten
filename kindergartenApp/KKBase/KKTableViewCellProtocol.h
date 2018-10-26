//
//  KKTableViewCellProtocol.h
//  kindergartenApp
//
//  Created by 尤彬 on 2018/10/25.
//  Copyright © 2018 youbin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KKTableViewCellProtocol <NSObject>

@optional

- (void) kk_setupView;

- (void) kk_bindViewModel;

@end
