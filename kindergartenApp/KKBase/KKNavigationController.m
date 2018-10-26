//
//  KKNavigationController.m
//  kindergartenApp
//
//  Created by 尤彬 on 2018/10/26.
//  Copyright © 2018 youbin. All rights reserved.
//

#import "KKNavigationController.h"
#import <objc/runtime.h>
static NSString * const KKNavigationControllerKey = @"KK.NavigationController.Key";

#pragma mark - 容器控制器
@interface KKContainerViewController : UIViewController

@property (nonatomic, weak) UIViewController *contentViewController;
@property (nonatomic, weak) UINavigationController *containerNavigationController;

+ (instancetype)containerViewControllerWithViewController:(UIViewController *)viewController;
- (instancetype)initWithViewController:(UIViewController *)viewController;

@end

@implementation KKContainerViewController

+ (instancetype)containerViewControllerWithViewController:(UIViewController *)viewController {
    return [[self alloc] initWithViewController:viewController];
}

- (instancetype)initWithViewController:(UIViewController *)viewController {
    if (self = [super init]) {
        if (viewController.parentViewController) {
            [viewController willMoveToParentViewController:nil];
            [viewController removeFromParentViewController];
        }
        
        Class cls = [viewController kk_navigationControllerClass];
        NSAssert(![cls isKindOfClass:UINavigationController.class], @"`-kk_navigationControllerClass` must return UINavigationController or it's subclass.");
        UINavigationController *navigationController = [[cls alloc] initWithRootViewController:viewController];
        navigationController.interactivePopGestureRecognizer.enabled = NO;
        
        self.contentViewController = viewController;
        self.containerNavigationController = navigationController;
        self.tabBarItem = viewController.tabBarItem;
        self.hidesBottomBarWhenPushed = viewController.hidesBottomBarWhenPushed;
        [self addChildViewController:navigationController];
        [self.view addSubview:navigationController.view];
        [navigationController didMoveToParentViewController:self];
    }
    return self;
}

@end


#pragma mark - 全局函数

/// 装包
UIKIT_STATIC_INLINE KKContainerViewController* KKWrapViewController(UIViewController *vc)
{
    if ([vc isKindOfClass:KKContainerViewController.class]) {
        return (KKContainerViewController*)vc;
    }
    return [KKContainerViewController containerViewControllerWithViewController:vc];
}

/// 解包
UIKIT_STATIC_INLINE UIViewController* KKUnwrapViewController(UIViewController *vc)
{
    if ([vc isKindOfClass:KKContainerViewController.class]) {
        return ((KKContainerViewController*)vc).contentViewController;
    }
    return vc;
}

/// 替换方法实现
UIKIT_STATIC_INLINE void kk_swizzled(Class class, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    if (class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


#pragma mark - 导航栏控制器

@interface KKNavigationController ()<UIGestureRecognizerDelegate>
@end

@implementation KKNavigationController

#pragma mark Lifecycle

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    KKContainerViewController *container = KKWrapViewController(viewController);
    if (self.viewControllers.count > 0) {
        // 返回按钮目前仅支持图片
        UIImage *backImage = nil;
        if (viewController.backIconImage) {
            backImage = viewController.backIconImage;
        } else if (container.containerNavigationController.backIconImage) {
            backImage = container.containerNavigationController.backIconImage;
        } else {
            backImage = self.backIconImage ?: [self navigationBarBackIconImage];
        }
        
        backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStylePlain target:viewController action:@selector(kk_popViewController)];
#pragma clang diagnostic pop
        viewController.navigationItem.leftBarButtonItem = backItem;
    }
    [super pushViewController:container animated:animated];
    
    // pop手势
    self.interactivePopGestureRecognizer.delaysTouchesBegan = YES;
    self.interactivePopGestureRecognizer.delegate = self;
    self.interactivePopGestureRecognizer.enabled = YES;
    
    /**
     * 保留一个`KKNavigationController`的弱引用
     * 用于解决用户执行 pop 后立即 push 的使用场景
     *
     * 示例代码:
     * UINavigationController *nav = self.navigationController;
     * [nav popViewControllerAnimated:NO];
     * [nav pushViewController:nil animated:YES];
     */
    objc_setAssociatedObject(container.containerNavigationController, &KKNavigationControllerKey, self, OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark <UIGestureRecognizerDelegate>

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        return (self.viewControllers.count > 1);
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

/// 在pop手势生效后能够确保滚动视图静止
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return (gestureRecognizer == self.interactivePopGestureRecognizer);
}

#pragma mark Private

- (void)commonInit {
    // 注意: 需要先隐藏导航栏再设置控制器，否则在某些低版本系统下有问题
    [self setNavigationBarHidden:YES animated:NO];
    UIViewController *topViewController = self.topViewController;
    if (topViewController) {
        UIViewController *wrapViewController = KKWrapViewController(topViewController);
        [super setViewControllers:@[wrapViewController] animated:NO];
    }
}



/**
 绘制返回按钮图片

 @return 按钮图片
 */
- (UIImage *)navigationBarBackIconImage {
    CGSize const size = CGSizeMake(15.0, 21.0);
    UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
    
    UIColor *color = [UIColor colorWithRed:0.42 green:0.42 blue:0.42 alpha:1.0];
    [color setFill];
    [color setStroke];
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(10.9, 0)];
    [bezierPath addLineToPoint: CGPointMake(12, 1.1)];
    [bezierPath addLineToPoint: CGPointMake(1.1, 11.75)];
    [bezierPath addLineToPoint: CGPointMake(0, 10.7)];
    [bezierPath addLineToPoint: CGPointMake(10.9, 0)];
    [bezierPath closePath];
    [bezierPath moveToPoint: CGPointMake(11.98, 19.9)];
    [bezierPath addLineToPoint: CGPointMake(10.88, 21)];
    [bezierPath addLineToPoint: CGPointMake(0.54, 11.21)];
    [bezierPath addLineToPoint: CGPointMake(1.64, 10.11)];
    [bezierPath addLineToPoint: CGPointMake(11.98, 19.9)];
    [bezierPath closePath];
    [bezierPath setLineWidth:0.3];
    [bezierPath fill];
    [bezierPath stroke];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark setter & getter

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden {
    [super setNavigationBarHidden:YES];
}

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated {
    [super setNavigationBarHidden:YES animated:NO];
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
    NSMutableArray<UIViewController *> *aViewControllers = [NSMutableArray array];
    for (UIViewController *vc in viewControllers) {
        [aViewControllers addObject:KKWrapViewController(vc)];
    }
    [super setViewControllers:aViewControllers animated:animated];
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
    NSMutableArray<UIViewController *> *aViewControllers = [NSMutableArray array];
    for (UIViewController *vc in viewControllers) {
        [aViewControllers addObject:KKWrapViewController(vc)];
    }
    [super setViewControllers:[NSArray arrayWithArray:aViewControllers]];
}

- (NSArray<UIViewController *> *)viewControllers {
    // 返回真正的控制器给外界
    NSMutableArray<UIViewController *> *vcs = [NSMutableArray array];
    NSArray<UIViewController *> *viewControllers = [super viewControllers];
    for (UIViewController *vc in viewControllers) {
        [vcs addObject:KKUnwrapViewController(vc)];
    }
    return [NSArray arrayWithArray:vcs];
}

@end


#pragma mark -

@implementation UIViewController (KKAdd)

/// 通过返回不同的导航栏控制器可以给每个控制器定制不同的导航栏样式
- (Class)kk_navigationControllerClass {
#ifdef kXPNavigationControllerClassName
    return NSClassFromString(kXPNavigationControllerClassName);
#else
    return [_KKContainerNavigationController class];
#endif
}

- (void)setBackIconImage:(UIImage *)backIconImage {
    objc_setAssociatedObject(self, @selector(backIconImage), backIconImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)backIconImage {
    return objc_getAssociatedObject(self, _cmd);
}

- (KKNavigationController *)kk_rootNavigationController {
    UIViewController *parentViewController = self.navigationController.parentViewController;
    if (parentViewController && [parentViewController isKindOfClass:KKContainerViewController.class]) {
        KKContainerViewController *container = (KKContainerViewController*)parentViewController;
        return (KKNavigationController*)container.navigationController;
    }
    return nil;
}

- (void)kk_popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

@end


#pragma mark -

@interface UINavigationController (KKAdd)

@end

@implementation UINavigationController (KKAdd)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *actions = @[
                             NSStringFromSelector(@selector(pushViewController:animated:)),
                             NSStringFromSelector(@selector(popViewControllerAnimated:)),
                             NSStringFromSelector(@selector(popToViewController:animated:)),
                             NSStringFromSelector(@selector(popToRootViewControllerAnimated:)),
                             NSStringFromSelector(@selector(viewControllers)),
                             NSStringFromSelector(@selector(tabBarController))
                             ];
        
        for (NSString *str in actions) {
            kk_swizzled(self, NSSelectorFromString(str), NSSelectorFromString([@"kk_" stringByAppendingString:str]));
        }
    });
}

#pragma mark Private

- (KKNavigationController *)rootNavigationController {
    if (self.parentViewController && [self.parentViewController isKindOfClass:KKContainerViewController.class]) {
        KKContainerViewController *containerViewController = (KKContainerViewController *)self.parentViewController;
        KKNavigationController *rootNavigationController = (KKNavigationController *)containerViewController.navigationController;
        // 如果用户执行了pop操作, 则此时`rootNavigationController`将为nil
        // 将尝试从关联对象中取出`KKNavigationController`
        return (rootNavigationController ?: objc_getAssociatedObject(self, &KKNavigationControllerKey));
    }
    return nil;
}

#pragma mark Override

- (void)kk_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    KKNavigationController *rootNavigationController = [self rootNavigationController];
    if (rootNavigationController) {
        return [rootNavigationController pushViewController:viewController animated:animated];
    }
    [self kk_pushViewController:viewController animated:animated];
}

- (UIViewController *)kk_popViewControllerAnimated:(BOOL)animated {
    KKNavigationController *rootNavigationController = [self rootNavigationController];
    if (rootNavigationController) {
        KKContainerViewController *containerViewController = (KKContainerViewController*)[rootNavigationController popViewControllerAnimated:animated];
        return containerViewController.contentViewController;
    }
    return [self kk_popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)kk_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    KKNavigationController *rootNavigationController = [self rootNavigationController];
    if (rootNavigationController) {
        KKContainerViewController *container = (KKContainerViewController*)viewController.navigationController.parentViewController;
        NSArray<UIViewController*> *array = [rootNavigationController popToViewController:container animated:animated];
        NSMutableArray *viewControllers = [NSMutableArray array];
        for (UIViewController *vc in array) {
            [viewControllers addObject:KKUnwrapViewController(vc)];
        }
        return viewControllers;
    }
    return [self kk_popToViewController:viewController animated:animated];
}

- (NSArray<UIViewController *> *)kk_popToRootViewControllerAnimated:(BOOL)animated {
    KKNavigationController *rootNavigationController = [self rootNavigationController];
    if (rootNavigationController) {
        NSArray<UIViewController*> *array = [rootNavigationController popToRootViewControllerAnimated:animated];
        NSMutableArray *viewControllers = [NSMutableArray array];
        for (UIViewController *vc in array) {
            [viewControllers addObject:KKUnwrapViewController(vc)];
        }
        return viewControllers;
    }
    return [self kk_popToRootViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)kk_viewControllers {
    KKNavigationController *rootNavigationController = [self rootNavigationController];
    if (rootNavigationController) {
        return [rootNavigationController viewControllers];
    }
    return [self kk_viewControllers];
}

- (UITabBarController *)kk_tabBarController {
    UITabBarController *tabController = [self kk_tabBarController];
    if (self.parentViewController && [self.parentViewController isKindOfClass:KKContainerViewController.class]) {
        if (self.viewControllers.count > 1 && self.topViewController.hidesBottomBarWhenPushed) {
            // 解决滚动视图在iOS11以下版本中底部留白问题
            return nil;
        }
        if (!tabController.tabBar.isTranslucent) {
            return nil;
        }
    }
    return tabController;
}

@end


#pragma mark - 状态栏样式 & 屏幕旋转

@implementation _KKContainerNavigationController

- (UIViewController *)childViewControllerForStatusBarStyle {
    if (self.topViewController) {
        return KKUnwrapViewController(self.topViewController);
    }
    return [super childViewControllerForStatusBarStyle];
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    if (self.topViewController) {
        return KKUnwrapViewController(self.topViewController);
    }
    return [super childViewControllerForStatusBarHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.topViewController) {
        return [KKUnwrapViewController(self.topViewController) preferredStatusBarStyle];
    }
    return [super preferredStatusBarStyle];
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    if (self.topViewController) {
        return [KKUnwrapViewController(self.topViewController) preferredStatusBarUpdateAnimation];
    }
    return [super preferredStatusBarUpdateAnimation];
}

- (BOOL)prefersStatusBarHidden {
    if (self.topViewController) {
        return [KKUnwrapViewController(self.topViewController) prefersStatusBarHidden];
    }
    return [super prefersStatusBarHidden];
}

- (BOOL)shouldAutorotate {
    if (self.topViewController) {
        return [KKUnwrapViewController(self.topViewController) shouldAutorotate];
    }
    return [super shouldAutorotate];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    if (self.topViewController) {
        return [KKUnwrapViewController(self.topViewController) preferredInterfaceOrientationForPresentation];
    }
    return [super preferredInterfaceOrientationForPresentation];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.topViewController) {
        return [KKUnwrapViewController(self.topViewController) supportedInterfaceOrientations];
    }
    return [super supportedInterfaceOrientations];
}

#if __IPHONE_11_0 && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0
- (nullable UIViewController *)childViewControllerForScreenEdgesDeferringSystemGestures
{
    if (self.topViewController) {
        return KKUnwrapViewController(self.topViewController);
    }
    return [super childViewControllerForScreenEdgesDeferringSystemGestures];
}

- (UIRectEdge)preferredScreenEdgesDeferringSystemGestures
{
    if (self.topViewController) {
        return [KKUnwrapViewController(self.topViewController) preferredScreenEdgesDeferringSystemGestures];
    }
    return [super preferredScreenEdgesDeferringSystemGestures];
}

- (BOOL)prefersHomeIndicatorAutoHidden
{
    if (self.topViewController) {
        return [KKUnwrapViewController(self.topViewController) prefersHomeIndicatorAutoHidden];
    }
    return [super prefersHomeIndicatorAutoHidden];
}

- (UIViewController *)childViewControllerForHomeIndicatorAutoHidden
{
    if (self.topViewController) {
        return KKUnwrapViewController(self.topViewController);
    }
    return [super childViewControllerForHomeIndicatorAutoHidden];
}
#endif

@end
