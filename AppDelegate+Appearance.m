//
//  AppDelegate+Appearance.m
//  kaixun
//
//  Created by 张凯 on 2017/9/22.
//  Copyright © 2017年 zhangkai. All rights reserved.
//

#import "AppDelegate+Appearance.h"

@implementation AppDelegate (Appearance)

- (void)setUpAppearance{
    [self setUpAppearanceForWindow];
    [self setUpAppearanceForNavigationBar];
}

- (void)setUpAppearanceForWindow{
    self.window.backgroundColor = [UIColor whiteColor];
}

- (void)setUpAppearanceForNavigationBar{
    UINavigationBar *appearanceNavigationBar = [UINavigationBar appearance];
//    [appearanceNavigationBar setTintColor:[UIColor colorWithDecimalRed:0 green:175 blue:240 alpha:1]];
    if ([[UINavigationBar class] instancesRespondToSelector:@selector(setBackIndicatorImage:)]) {
        //自定义返回图片
        UIImage *backImage = [UIImage imageNamed:@"nav_back"];
        appearanceNavigationBar.backIndicatorImage = backImage;
        appearanceNavigationBar.backIndicatorTransitionMaskImage = backImage;
        //去除返回文字
//        [UIBarButtonItem.appearance setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -64) forBarMetrics:UIBarMetricsDefault];
    }
    
}

@end
