//
//  KXNavControlDelegate.m
//  kaixun
//
//  Created by 张凯 on 2018/3/31.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "KXNavControlDelegate.h"

@implementation KXNavControlDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if (self.transition) {
        Class transition = NSClassFromString(self.transition);
        return [transition new];
    }
    return nil;
}
@end
