//
//  BSNavigationController.m
//  UINavigationController
//
//  Created by 张宝山 on 2019/11/15.
//  Copyright © 2019 张宝山. All rights reserved.
//

#import "BSNavigationController.h"

@interface BSNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIViewController *currentShowViewController;

@end

@implementation BSNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    
    BSNavigationController *nav = [super initWithRootViewController:rootViewController];
    UIImage *image = [UIImage imageNamed:@"JWDemo_Back"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.navigationBar.backIndicatorImage = image;
    nav.navigationBar.backIndicatorTransitionMaskImage = image;
    nav.interactivePopGestureRecognizer.delegate = self;
    nav.delegate = self;
    return nav;
}

#pragma mark - UIGestureRecognizerDelegate
//这个方法在视图控制器完成push时候调用
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    
    if (navigationController.viewControllers.count == 1) {
        //如果堆栈内的视图控制器数量为1时,说明只有根控制器 将currentShowViewController清空 为了下面的方法禁用侧滑手势
        self.currentShowViewController = nil;
    }else{
        //将push过来的视图控制器赋值给currentShowController
        self.currentShowViewController = viewController;
    }
}

//这个方法是在手势将要激活前调用: 返回YES 允许侧滑手势的激活, 返回NO不允许侧滑手势的激活
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    //确定是否是需要管理的侧滑手势
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        if (self.currentShowViewController == self.topViewController) {
            //如果currentShowController 不存子禁用侧滑手势
            return YES;
        }
    }
    //侧滑手势统一激活
    return YES;
}

//获取侧滑返回手势
- (UIScreenEdgePanGestureRecognizer *)screenEdgePanGestureRecognizer
{
    UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = nil;
    if (self.view.gestureRecognizers.count > 0)
    {
        for (UIGestureRecognizer *recognizer in self.view.gestureRecognizers)
        {
            if ([recognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]])
            {
                screenEdgePanGestureRecognizer = (UIScreenEdgePanGestureRecognizer *)recognizer;
                break;
            }
        }
    }
    return screenEdgePanGestureRecognizer;
}

/**
 //禁止侧滑手势和tableView同时滑动 (在跳转的UIViewController里写)
 BSNavigationController *navController = (BSNavigationController *)self.navigationController;
 if ([navController screenEdgePanGestureRecognizer]) {
     //指定滑动手势在侧滑返回手势失效后响应
     [self.friendsDemoTableView.panGestureRecognizer requireGestureRecognizerToFail:[navController screenEdgePanGestureRecognizer]];
 }
 
 设置跳转后左上角返回标题
 A push B
 在A中设置
 UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
 backItem.title = @"";
 self.navigationItem.backBarButtonItem = backItem;
 
 或者github第三方框架 FDFullscreenPopGesture 一个分类解决
 */


@end
