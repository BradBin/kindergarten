//
//  KKView.m
//  kindergartenApp
//
//  Created by 尤彬 on 2018/10/25.
//  Copyright © 2018 youbin. All rights reserved.
//

#import "KKView.h"
#import "AppDelegate.h"

@implementation KKView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self kk_bindViewModel];
        [self kk_setupView];
    }
    return self;
}


- (instancetype)initWithViewModel:(id<KKViewModelProtocol>)viewModel{
    self = [super init];
    if (self) {
        [self kk_bindViewModel];
        [self kk_setupView];
    }
    return self;
}



-(void)kk_bindViewModel{}


- (void)kk_setupView{}



-(void)kk_addReturnKeyBoard{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(tapAction)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
    
}


- (void) tapAction{
    AppDelegate *app = (AppDelegate *)UIApplication.sharedApplication.delegate;
    [app.window endEditing:true];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
