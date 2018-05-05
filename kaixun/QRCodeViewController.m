//
//  QRViewController.m
//  kaixun
//
//  Created by 张凯 on 2016/11/23.
//  Copyright © 2016年 zhangkai. All rights reserved.
//

#import "QRCodeViewController.h"
@interface QRCodeViewController ()
@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的二维码";
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(cancelEvent:)];
//    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = backBtn;
    [self.navigationController.navigationBar setTintColor:TEXTCOLOR];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


#pragma mark - Event Response
- (void)cancelEvent:(UIButton *)sender
{
    
    [self dismissViewControllerAnimated:NO completion:^{
        if ([(id)self.delegate respondsToSelector:@selector(backMessageVC)]) {
            [self.delegate backMessageVC];
        }
    }];
}

#pragma mark - Lazy Load
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
