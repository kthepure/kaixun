//
//  MBProgressHUD+Extend.m
//  TQProduction
//
//  Created by LuPengDa on 15/11/4.
//  Copyright © 2015年 CTTQ. All rights reserved.
//

#define kDurationTime 1.5
#define kHideDelay 1
#import "MBProgressHUD+Extend.h"


static MBProgressHUD *_hud;
static MBProgressHUD *_obj;
@implementation MBProgressHUD (Extend)

+ (instancetype)showHUDWithMessage:(NSString *)message
{
    return [self showHUDWithMessage:message modeText:NO];
}

+ (instancetype)showHUDWithMessage:(NSString *)message modeText:(BOOL)flag
{
    return [self showHUDAddedTo:[UIApplication sharedApplication].keyWindow withMessage:message modeText:flag];
}

+ (instancetype)showHUDAddedTo:(UIView *)view withMessage:(NSString *)message modeText:(BOOL)flag
{
    [MBProgressHUD hideHUDForView:view animated:YES];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    
    hud.removeFromSuperViewOnHide = YES;
    
    if (flag) {
        hud.contentColor = [UIColor whiteColor];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = message;
    }else{
        hud.mode = MBProgressHUDModeCustomView;
        hud.contentColor = [UIColor clearColor];
        UIImageView *hudImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        NSMutableArray *imgsArr = [NSMutableArray array];
        for (int i = 0; i < 14; i ++) {
            NSString *imgStr = [NSString stringWithFormat:@"Preloader_1_000%02d",i];
            [imgsArr addObject:[UIImage imageNamed:imgStr]];
        }
        hudImageView.animationImages = imgsArr;
        hudImageView.animationDuration = 1;
        [hudImageView startAnimating];
        
        hud.bezelView.color = [UIColor clearColor];
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.customView = hudImageView;
        
        [hudImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
    }
    [view addSubview:hud];
    [hud showAnimated:YES];
    return hud;
}

+ (instancetype)alertDialogWithTitle:(NSString *)title message:(NSString *)message andAutoHideAfterDelay:(NSTimeInterval)delay
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [MBProgressHUD hideHUDForView:window animated:YES];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:window];
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeText;
    
    hud.contentColor = [UIColor whiteColor];
    hud.label.text = title;
    hud.label.textColor = [UIColor whiteColor];
    hud.detailsLabel.text = message;
    
    [window addSubview:hud];
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:delay];
    return hud;
}

@end


@implementation MBProgressHUD (TOAST)

+ (instancetype)toastWithMessage:(NSString *)message
{
    return [self toastWithMessage:message position:ToastPositionBottom];
}

+ (instancetype)toastWithMessage:(NSString *)message position:(ToastPosition)position
{
    CGFloat yOffset = 0.0f;
    CGFloat ratio = 0.2;
    CGFloat height = CGRectGetHeight([UIApplication sharedApplication].keyWindow.frame);
    switch (position) {
        case ToastPositionTop:
        {
            yOffset = height * (ratio - 0.5);
        }
            break;
        case ToastPositionBottom:
        {
            yOffset = height * (0.5 - ratio);
        }
            break;
        default:
            break;
    }
    return [self toastWithMessage:message yOffset:yOffset];
}

+ (instancetype)toastWithMessage:(NSString *)message yOffset:(CGFloat)yOffset
{
    // hide ,每次只显示一个
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [MBProgressHUD hideHUDForView:keyWindow animated:YES];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:keyWindow];
    
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;
    
    hud.mode = MBProgressHUDModeText;
    hud.contentColor = [UIColor whiteColor];
    hud.detailsLabel.font = [UIFont systemFontOfSize:13];
    hud.detailsLabel.textColor = [UIColor whiteColor];
    hud.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    hud.margin = 10.0f;
    hud.bezelView.layer.cornerRadius = 5.0f;
    
    hud.detailsLabel.text = message;
    hud.offset = CGPointMake(hud.offset.x, yOffset);;
    
    [keyWindow addSubview:hud];
    [hud showAnimated:YES];
    
    [hud hideAnimated:YES afterDelay:kDurationTime];
    return hud;
}

+ (instancetype)toastWithAlertType:(ToastAlertType)alertType message:(NSString *)message position:(ToastPosition)position
{
    //提示图标
    NSString *imageName = nil;
    switch (alertType) {
        case ToastAlertTypeSuccess: {
            imageName = @"ico_chenggong";
            break;
        }
        case ToastAlertTypeFailture: {
            imageName = @"ico_shibai";
            break;
        }
        case ToastAlertTypeWarning: {
            imageName = @"ico-tishi";
            break;
        }
        default:break;
    }
    
    // 位置
    CGFloat yOffset = 0.0f;
    CGFloat ratio = 0.2;
    CGFloat height = CGRectGetHeight([UIApplication sharedApplication].keyWindow.frame);
    switch (position) {
        case ToastPositionTop:
        {
            yOffset = height * (ratio - 0.5);
        }
            break;
        case ToastPositionBottom:
        {
            yOffset = height * (0.5 - ratio);
        }
            break;
        default:
            break;
    }
    
    // hide ,每次只显示一个
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [MBProgressHUD hideHUDForView:keyWindow animated:YES];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:keyWindow];
    
    [hud setRemoveFromSuperViewOnHide:YES];
    [hud setMargin:12.0f];
    [hud.bezelView.layer setCornerRadius:10.0f];
    [hud setOffset:CGPointMake(hud.offset.x, yOffset)];
    
    [hud setContentColor:[UIColor whiteColor]];
    [hud.label setFont:[UIFont systemFontOfSize:15]];
    [hud.label setTextColor:[UIColor whiteColor]];
    [hud.bezelView setColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
    [hud.label setText:message];
    [hud.label setNumberOfLines:0];
    
    if (alertType != ToastAlertTypePending) {
        [hud setUserInteractionEnabled:NO];
        [hud setMode:MBProgressHUDModeCustomView];
        UIImageView *hudImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        [hudImageView setContentMode:UIViewContentModeCenter];
        [hudImageView setBounds:CGRectMake(0, 0, CGRectGetWidth(hudImageView.bounds) + 17, CGRectGetHeight(hudImageView.bounds) + 17)];
        [hud setCustomView:hudImageView];
    } else {
        [hud setUserInteractionEnabled:YES];
    }
    
    [keyWindow addSubview:hud];
    [hud showAnimated:YES];
    if (alertType != ToastAlertTypePending) {
        [hud hideAnimated:YES afterDelay:kDurationTime];
    }
    return hud;
}

+ (instancetype)toastWithSuccess:(NSString *)message
{
    return [self toastWithAlertType:ToastAlertTypeSuccess message:message position:ToastPositionCenter];
}

+ (instancetype)toastWithFailture:(NSString *)message
{
    return [self toastWithAlertType:ToastAlertTypeFailture message:message position:ToastPositionCenter];
}

+ (instancetype)toastWithWarning:(NSString *)message
{
    return [self toastWithAlertType:ToastAlertTypeWarning message:message position:ToastPositionCenter];
}

+ (instancetype)toastWithPending:(NSString *)message
{
    return [self toastWithAlertType:ToastAlertTypePending message:message position:ToastPositionCenter];
}


+ (MBProgressHUD *)showHUDMessage:(NSString *)message addedTo:(UIView *)view autoHide:(BOOL)autoHide textOnly:(BOOL)textOnly
{
    if (_hud) {
        [_hud hide:YES];
    }
    
    _hud = [MBProgressHUD showHUDAddedTo:view animated:autoHide];
    _hud.labelText = message;
    _hud.removeFromSuperViewOnHide = YES;
    
    if (textOnly) {
        _hud.mode = MBProgressHUDModeText;
    }
    
    if (autoHide) {
        [_hud hide:YES afterDelay:kHideDelay];
        
        // 为了解决偶尔不能自动隐藏，额外做了一次隐藏处理
        if (!_obj) {
            _obj = [[MBProgressHUD alloc] init];
        }
        [_obj performSelector:@selector(delayHide) withObject:nil afterDelay:kHideDelay + 0.5];
    }
    
    return _hud;
}

- (void)delayHide
{
    [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
}



@end
