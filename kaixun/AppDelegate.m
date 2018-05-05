//
//  AppDelegate.m
//  kaixun
//
//  Created by 张凯 on 2017/5/9.
//  Copyright © 2017年 zhangkai. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Appearance.h"
#import "LoginViewController.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>
@interface AppDelegate ()<IChatManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setUpAppearance];
    // Override point for customization after application launch.
    LoginViewController *vc = [[LoginViewController alloc] init];
    
    UINavigationController *nav= [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    //注册环信
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"1153161109178002#kaixunforinstantmessage" apnsCertName:@"kaixun"];
    //注册一个监听对象到监听列表
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    //百度地图
    // 要使用百度地图，请先启动BaiduMapManager
    BMKMapManager* _mapManager = [[BMKMapManager alloc]init];
    
    /**
     *百度地图SDK所有接口均支持百度坐标（BD09）和国测局坐标（GCJ02），用此方法设置您使用的坐标类型.
     *默认是BD09（BMK_COORDTYPE_BD09LL）坐标.
     *如果需要使用GCJ02坐标，需要设置CoordinateType为：BMK_COORDTYPE_COMMON.
     */
    if ([BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_BD09LL]) {
        TQLog(@"经纬度类型设置成功");
    } else {
        TQLog(@"经纬度类型设置失败");
    }
    
    BOOL ret = [_mapManager start:@"Uyidz85sjArlGqh2doWHHBpN" generalDelegate:self];
    if (!ret) {
        TQLog(@"manager start failed!");
    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}

//监听好友申请消息
- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message
{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:username,@"username",message,@"message", nil];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:dic forKey:@"dic"];
    
    [userDefaults synchronize];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"来自%@的好友申请",username] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:ok];
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    
}


@end
