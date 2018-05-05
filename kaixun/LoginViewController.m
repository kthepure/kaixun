//
//  ViewController.m
//  kaixun
//
//  Created by 张凯 on 2016/11/11.
//  Copyright © 2016年 zhangkai. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "MessageViewController.h"
#import "ContactViewController.h"
#import "ZoneViewController.h"
#import "DDMenuController.h"
#import "LeftViewController.h"
#import "MBProgressHUD.h"
@interface LoginViewController ()
@property (nonatomic, strong) UIButton *headBut;
@property (nonatomic, strong) UITextField *userNameText;
@property (nonatomic, strong) UITextField *password;
@property (nonatomic, strong) UIButton *loginBut;
@property (nonatomic, strong) UIButton *tickIconBut;//打钩按钮
@property (nonatomic, assign) BOOL isChooseTick;
@property (nonatomic, strong) UILabel *agreeLab;
@property (nonatomic, strong) UIButton *serviceProvision;//服务条款
@property (nonatomic, strong) UIButton *unableLoginBut;
@property (nonatomic, strong) UIButton *registerBut;
//@property (nonatomic, strong) UITabBarController *tabBarController;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithDecimalRed:245 green:247 blue:250 alpha:1];
    [self.navigationController setNavigationBarHidden:YES];
    
    self.isChooseTick = YES;
    
    [self.view addSubview:self.headBut];
    [self.view addSubview:self.userNameText];
    [self.view addSubview:self.password];
    [self.view addSubview:self.loginBut];
    [self.view addSubview:self.tickIconBut];
    [self.view addSubview:self.agreeLab];
    [self.view addSubview:self.serviceProvision];
    [self.view addSubview:self.unableLoginBut];
    [self.view addSubview:self.registerBut];
    [self subviewLayout];
    [self createTabBarMethod];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
}

- (DDMenuController *)createTabBarMethod{
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    MessageViewController *messageVC = [[MessageViewController alloc] init];
    UITabBarItem *messageItem = [[UITabBarItem alloc] initWithTitle:@"消息" image:[UIImage imageNamed:@"menu-message-hover"] tag:0];
    messageVC.tabBarItem = messageItem;
    UINavigationController *messageNav = [[UINavigationController alloc] initWithRootViewController:messageVC];
    
    ContactViewController *contactVC = [[ContactViewController alloc] init];
    UITabBarItem *contactItem = [[UITabBarItem alloc] initWithTitle:@"联系人" image:[UIImage imageNamed:@"menu-contact-hover"] tag:1];
    contactVC.tabBarItem = contactItem;
    UINavigationController *contactNav = [[UINavigationController alloc] initWithRootViewController:contactVC];
    
    ZoneViewController *zoneVC = [[ZoneViewController alloc] init];
    UITabBarItem *zoneItem = [[UITabBarItem alloc] initWithTitle:@"空间" image:[UIImage imageNamed:@"menu-zone-hover"] tag:2];
    zoneVC.tabBarItem = zoneItem;
    UINavigationController *zoneNav = [[UINavigationController alloc] initWithRootViewController:zoneVC];
    
    NSArray *array = [[NSArray alloc] initWithObjects:messageNav,contactNav,zoneNav, nil];
    tabBarController.viewControllers = array;
    tabBarController.tabBar.tintColor = [UIColor colorWithDecimalRed:0 green:175 blue:240 alpha:1];
    DDMenuController *ddMenu = [[DDMenuController alloc] initWithRootViewController:tabBarController];
    [ddMenu.pan setEnabled:YES];
    LeftViewController *leftCon = [[LeftViewController alloc] init];
    UINavigationController *leftNav = [[UINavigationController alloc] initWithRootViewController:leftCon];
    ddMenu.leftViewController = leftNav;
    return ddMenu;
}

- (void)subviewLayout{
    [self.headBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20 + 35);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    [self.userNameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headBut.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    [self.password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameText.mas_bottom).offset(1);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    [self.loginBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.password.mas_bottom).offset(15);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(40);
    }];
    [self.tickIconBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginBut.mas_bottom).offset(20);
        make.left.equalTo(self.loginBut);
    }];
    [self.agreeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.tickIconBut);
        make.left.equalTo(self.tickIconBut.mas_right).offset(4);
    }];
    [self.serviceProvision mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.tickIconBut);
        make.left.equalTo(self.agreeLab.mas_right).offset(10);
    }];
    [self.unableLoginBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.bottom.equalTo(self.view).offset(-15);
    }];
    [self.registerBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-15);
    }];
//    self.agreeLab.userInteractionEnabled = YES;
//    UIButton *but = [[UIButton alloc] init];
//    [but setBackgroundColor:[UIColor grayColor]];
//    [but addTarget:self action:@selector(test1) forControlEvents:UIControlEventTouchUpInside];
//    [self.agreeLab addSubview:but];
//    [but mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.agreeLab);
//        make.left.equalTo(self.agreeLab).offset(15);
//        make.size.mas_equalTo(CGSizeMake(30, 20));
//    }];
}
//- (void)test1{
//    NSLog(@"11122222");
//}
//换头像按钮
- (void)headButAction{
    
}
//登录按钮
- (void)loginButAction{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.alpha = 0.5;
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:self.userNameText.text password:self.password.text completion:^(NSDictionary *loginInfo, EMError *error) {
        [hud hideAnimated:YES];
        if (!error) {
            [UIApplication sharedApplication].keyWindow.rootViewController = [self createTabBarMethod];
            [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
        }else{
            NSLog(@"登录失败:%@",error);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"用户名或密码不正确" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];
            [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(createAlert:) userInfo:alert repeats:NO];
        }
    } onQueue:dispatch_get_main_queue()];
}
//阅读并同意按钮
- (void)tickIconButAction:(UIButton *)sender{
    if (self.isChooseTick != NO) {
        [self.tickIconBut setImage:[UIImage imageNamed:@"s260_btn_selected"] forState:UIControlStateNormal];
        self.isChooseTick = NO;
        [self.loginBut setBackgroundColor:GRAYTEXTCOLOR];
        [self.loginBut setEnabled:NO];
    }else{
        [self.tickIconBut setImage:[UIImage imageNamed:@"s260_btn_selected_s"] forState:UIControlStateNormal];
        self.isChooseTick = YES;
        [self.loginBut setBackgroundColor:BLUETEXTCOLOR];
        [self.loginBut setEnabled:YES];
    }
}
//注册按钮
- (void)registerButAction{
    RegisterViewController *vc = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
//无法登陆
- (void)unableLoginButAction{
    
}
- (void)createAlert:(NSTimer *)timer{
    UIAlertController *alert = [timer userInfo];
    [alert dismissViewControllerAnimated:YES completion:nil];
    alert = nil;
}
- (BOOL)isEmpty{
    BOOL ret = NO;
    if (self.userNameText.text.length == 0 || self.password.text.length == 0) {
        ret = YES;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"输入不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction *OK = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:cancel];
        [alert addAction:OK];
        [self presentViewController:alert animated:YES completion:nil];
    }
    return ret;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.userNameText resignFirstResponder];
    [self.password resignFirstResponder];
}
#pragma mark subview
-(UIButton *)headBut{
    if (!_headBut) {
        _headBut = [[UIButton alloc] init];
        [_headBut setImage:[UIImage imageNamed:@"LoginWindow_BigDefaultHeadImage"] forState:UIControlStateNormal];
        _headBut.layer.cornerRadius = 40;
        _headBut.layer.masksToBounds = YES;
        [_headBut addTarget:self action:@selector(headButAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headBut;
}
-(UITextField *)userNameText{
    if (!_userNameText) {
        _userNameText = [[UITextField alloc] init];
        _userNameText.backgroundColor = [UIColor whiteColor];
        _userNameText.placeholder = @"QQ号/手机号/邮箱";
        _userNameText.font = [UIFont systemFontOfSize:21];
        _userNameText.textAlignment = NSTextAlignmentCenter;
        //UITextField文字距左边框距离
//        _userNameText.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
//        _userNameText.leftViewMode = UITextFieldViewModeAlways;
        _userNameText.clearButtonMode = UITextFieldViewModeWhileEditing;
#ifdef SIMULATOR_IPHONE
        _userNameText.text = @"123";
#else
        _userNameText.text = @"234";
#endif
//        _userNameText.autocorrectionType = UITextAutocorrectionTypeYes;//自动纠错
        _userNameText.adjustsFontSizeToFitWidth = YES;
        _userNameText.minimumFontSize = 14;
    }
    return _userNameText;
}
-(UITextField *)password{
    if (!_password) {
        _password = [[UITextField alloc] init];
        _password.backgroundColor = [UIColor whiteColor];
        _password.placeholder = @"密码";
        _password.font = [UIFont systemFontOfSize:21];
        _password.textAlignment = NSTextAlignmentCenter;
//        _password.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
//        _password.leftViewMode = UITextFieldViewModeAlways;
        _password.clearButtonMode = UITextFieldViewModeWhileEditing;
#ifdef SIMULATOR_IPHONE
        _password.text = @"123";
#else
        _password.text = @"234";
#endif
    }
    return _password;
}
-(UIButton *)loginBut{
    if (!_loginBut) {
        _loginBut = [[UIButton alloc] init];
        [_loginBut setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBut setBackgroundColor:BLUETEXTCOLOR];
        _loginBut.layer.cornerRadius = 4;
        _loginBut.layer.masksToBounds = YES;
        [_loginBut addTarget:self action:@selector(loginButAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBut;
}
-(UIButton *)tickIconBut{
    if (!_tickIconBut) {
        _tickIconBut = [[UIButton alloc] init];
        [_tickIconBut setImage:[UIImage imageNamed:@"s260_btn_selected_s"] forState:UIControlStateNormal];
        [_tickIconBut addTarget:self action:@selector(tickIconButAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tickIconBut;
}
-(UILabel *)agreeLab{
    if (!_agreeLab) {
        _agreeLab = [[UILabel alloc] init];
        _agreeLab.text = @"我已阅读并同意";
        _agreeLab.textColor = [UIColor colorWithDecimalRed:170 green:178 blue:189 alpha:1];
    }
    return _agreeLab;
}
-(UIButton *)serviceProvision{
    if (!_serviceProvision) {
        _serviceProvision = [[UIButton alloc] init];
        [_serviceProvision setTitle:@"服务条款" forState:UIControlStateNormal];
        [_serviceProvision setTitleColor:[UIColor colorWithDecimalRed:0 green:175 blue:240 alpha:1] forState:UIControlStateNormal];
    }
    return _serviceProvision;
}
-(UIButton *)unableLoginBut{
    if (!_unableLoginBut) {
        _unableLoginBut = [[UIButton alloc] init];
        [_unableLoginBut setTitle:@"无法登陆？" forState:UIControlStateNormal];
        [_unableLoginBut setTitleColor:[UIColor colorWithDecimalRed:0 green:175 blue:240 alpha:1] forState:UIControlStateNormal];
        [_unableLoginBut addTarget:self action:@selector(unableLoginButAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _unableLoginBut;
}
-(UIButton *)registerBut{
    if (!_registerBut) {
        _registerBut = [[UIButton alloc] init];
        [_registerBut setTitle:@"新用户注册" forState:UIControlStateNormal];
        [_registerBut setTitleColor:[UIColor colorWithDecimalRed:0 green:175 blue:240 alpha:1] forState:UIControlStateNormal];
        [_registerBut addTarget:self action:@selector(registerButAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBut;
}





@end
