//
//  MBProgressHUD+Extend.h
//  TQProduction
//
//  Created by LuPengDa on 15/11/4.
//  Copyright © 2015年 CTTQ. All rights reserved.
//


#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (Extend)

+ (instancetype)showHUDWithMessage:(NSString *)message;

+ (instancetype)showHUDWithMessage:(NSString *)message modeText:(BOOL)flag;

+ (instancetype)showHUDAddedTo:(UIView *)view withMessage:(NSString *)message modeText:(BOOL)flag;

+ (instancetype)alertDialogWithTitle:(NSString *)title message:(NSString *)message andAutoHideAfterDelay:(NSTimeInterval)delay;

@end

#pragma mark - Toast

/// Toast显示位置
typedef NS_ENUM(NSInteger, ToastPosition) {
    ToastPositionCenter,        ///< 显示在整个屏幕的中心位置
    ToastPositionTop,           ///< 显示在整个屏幕的偏上位置
    ToastPositionBottom,        ///< 显示在整个屏幕的偏下位置
};

/// Toast提示类型
typedef NS_ENUM(NSInteger, ToastAlertType) {
    ToastAlertTypeSuccess,      ///< 成功 不锁定,3秒后自动隐藏
    ToastAlertTypeFailture,     ///< 失败 不锁定,3秒后自动隐藏
    ToastAlertTypeWarning,      ///< 警告 不锁定,3秒后自动隐藏
    ToastAlertTypePending,      ///< 等待 锁定窗口,需手动隐藏
};

@interface MBProgressHUD (TOAST)

#pragma mark - 只有文本的提示
+ (instancetype)toastWithMessage:(NSString *)message;

+ (instancetype)toastWithMessage:(NSString *)message position:(ToastPosition)position;

+ (instancetype)toastWithMessage:(NSString *)message yOffset:(CGFloat)yOffset;

#pragma mark - 带提示图标
+ (instancetype)toastWithAlertType:(ToastAlertType)alertType message:(NSString *)message position:(ToastPosition)position;

#pragma mark 居中的提示图标
+ (instancetype)toastWithSuccess:(NSString *)message;
+ (instancetype)toastWithFailture:(NSString *)message;
+ (instancetype)toastWithWarning:(NSString *)message;
+ (instancetype)toastWithPending:(NSString *)message;


/**
 *  @brief  显示文本到指定View
 *
 *  @param  message   需要显示的文本信息
 *  @param  view      被添加显示的View
 *  @param  autoHide  是否自动隐藏
 *  @param  textOnly  是否只显示文本
 *
 *  @return MBProgressHUD
 */
+ (MBProgressHUD *)showHUDMessage:(NSString *)message addedTo:(UIView *)view autoHide:(BOOL)autoHide textOnly:(BOOL)textOnly;



@end

NS_ASSUME_NONNULL_END
