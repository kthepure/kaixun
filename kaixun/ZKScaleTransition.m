//
//  ZKScaleTransition.m
//  kaixun
//
//  Created by 张凯 on 2018/3/28.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "ZKScaleTransition.h"

@implementation ZKScaleTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.5f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *toVC = (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    [containerView addSubview:toView];
    [[transitionContext containerView] bringSubviewToFront:fromView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        fromView.alpha = 0.0;
        fromView.transform = CGAffineTransformMakeScale(0.2, 0.2);
        toView.alpha = 1.0;
    } completion:^(BOOL finished) {
        fromView.transform = CGAffineTransformMakeScale(1, 1);
        [transitionContext completeTransition:YES];
    }];
}
@end
