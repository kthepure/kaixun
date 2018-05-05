//
//  RegisterViewController.m
//  kaixun
//
//  Created by 张凯 on 2016/11/14.
//  Copyright © 2016年 zhangkai. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()
@property (nonatomic, strong) UITextField *userNameText;
@property (nonatomic, strong) UITextField *password;
@property (nonatomic, strong) UIButton *registerBut;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithDecimalRed:245 green:247 blue:250 alpha:1];
    self.navigationItem.title = @"注册";
    [self.view addSubview:self.userNameText];
    [self.view addSubview:self.password];
    [self.view addSubview:self.registerBut];
    [self subviewLayout];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)subviewLayout{
    [self.userNameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(145);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    [self.password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameText.mas_bottom).offset(1);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    [self.registerBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.password.mas_bottom).offset(15);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(40);
    }];

}

- (void)registerButAction:(UIButton *)sender{
    /*
     登录和注册有三种方式
     1.同步方法
     2.通过delegate回调的异步方法
     3.block异步方法
     官方推荐使用block异步方法，所以这里使用block异步方法
     */
    //开始注册
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:self.userNameText.text password:self.password.text withCompletion:^(NSString *username, NSString *password, EMError *error) {
        if (!error) {
            NSLog(@"注册成功");
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSLog(@"注册失败:%@",error);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"注册失败" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];
            [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(createAlert:) userInfo:alert repeats:NO];
        }
    } onQueue:dispatch_get_main_queue()];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.userNameText resignFirstResponder];
    [self.password resignFirstResponder];
}
- (void)createAlert:(NSTimer *)timer{
    UIAlertController *alert = [timer userInfo];
    [alert dismissViewControllerAnimated:YES completion:nil];
    alert = nil;
}
#pragma mark subview
-(UITextField *)userNameText{
    if (!_userNameText) {
        _userNameText = [[UITextField alloc] init];
        _userNameText.backgroundColor = [UIColor whiteColor];
        _userNameText.placeholder = @"QQ号/手机号/邮箱";
        _userNameText.textAlignment = NSTextAlignmentCenter;
    }
    return _userNameText;
}
-(UITextField *)password{
    if (!_password) {
        _password = [[UITextField alloc] init];
        _password.backgroundColor = [UIColor whiteColor];
        _password.placeholder = @"密码";
        _password.textAlignment = NSTextAlignmentCenter;
    }
    return _password;
}
-(UIButton *)registerBut{
    if (!_registerBut) {
        _registerBut = [[UIButton alloc] init];
        [_registerBut setTitle:@"注册" forState:UIControlStateNormal];
        [_registerBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_registerBut setBackgroundColor:[UIColor colorWithDecimalRed:0 green:175 blue:240 alpha:1]];
        _registerBut.layer.cornerRadius = 4;
        _registerBut.layer.masksToBounds = YES;
        [_registerBut addTarget:self action:@selector(registerButAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBut;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
