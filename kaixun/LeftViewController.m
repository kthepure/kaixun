//
//  MainViewController.m
//  kaixun
//
//  Created by 张凯 on 2016/11/15.
//  Copyright © 2016年 zhangkai. All rights reserved.
//

#import "LeftViewController.h"
#import "QRCodeViewController.h"
#import "LoginViewController.h"
#import "DDMenuController.h"
#import "MessageViewController.h"
#define rootConTrollerWidth self.view.frame.size.width/5

@interface LeftViewController ()<UITableViewDelegate,UITableViewDataSource,BackMessageVCWhenDismissRQCodeVCDelegate>
@property (nonatomic, strong)UIScrollView *headScrollview;
@property (nonatomic, strong)UIImageView *bgImageV;
@property (nonatomic, strong)UIButton *QRCodeBut;
@property (nonatomic, strong)UIImageView *headImageV;
@property (nonatomic, strong)UILabel *nameLab;
@property (nonatomic, strong)UIImageView *gradeImageV;
@property (nonatomic, strong)UIButton *personalizedSignatureBut;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, assign)CGPoint bottomOffset;
@property (nonatomic, assign)CGFloat currenOffsetY;

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *sidebarIconList;
@property (nonatomic, strong)NSArray *sidebarNameList;
@property (nonatomic, strong)UIButton *settingBut;
@property (nonatomic, strong)UIButton *nightmodeoffBut;
@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.currenOffsetY = 0;
    self.sidebarIconList = @[@"profile_item_privilege",@"sidebar_purse",@"sidebar_decoration",@"sidebar_album",@"sidebar_file"];
    self.sidebarNameList = @[@"激活会员",@"QQ钱包",@"个性装扮",@"我的相册",@"我的文件"];
    [self updateUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    self.bottomOffset = CGPointMake(self.headScrollview.contentOffset.x, self.headScrollview.contentSize.height - self.headScrollview.bounds.size.height);
    float scrollDurationInSeconds = 15.0;
    // 计算timer间隔
    float timerInterval = scrollDurationInSeconds/self.bottomOffset.y;
    
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:timerInterval target:self selector:@selector(scrollScrollView:) userInfo:nil repeats:YES];
        //在开启一个NSTimer实质上是在当前的runloop中注册了一个新的事件源，而当scrollView滚动的时候，当前的MainRunLoop是处于UITrackingRunLoopMode的模式下，在这个模式下，是不会处理NSDefaultRunLoopMode的消息(因为RunLoop Mode不一样)，要想在scrollView滚动的同时也接受其它runloop的消息，我们需要改变两者之间的runloopmode.
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //去除下一级视图的leftBarButtonItem的title
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}
- (void)updateUI{
    [self.view addSubview:self.headScrollview];
    [self.headScrollview addSubview:self.bgImageV];
    [self.headScrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(220);
    }];
    [self.bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.headScrollview);
        make.width.mas_equalTo(self.headScrollview);
    }];
    //解决headScrollview无法上下滑动
    [self.view layoutIfNeeded];
    self.headScrollview.contentSize = CGSizeMake(self.view.frame.size.width, 500);
    
    [self.view addSubview:self.QRCodeBut];
    [self.QRCodeBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-(rootConTrollerWidth + 20));
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.view addSubview:self.headImageV];
    [self.view addSubview:self.nameLab];
    [self.view addSubview:self.gradeImageV];
    [self.view addSubview:self.personalizedSignatureBut];
    [self.headImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(110);
        make.left.equalTo(self.view).offset(20);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageV.mas_right).offset(10);
        make.centerY.equalTo(self.headImageV);
    }];
    [self.gradeImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageV.mas_bottom).offset(5);
        make.left.equalTo(self.headImageV);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    UIImageView *sunImage1 = [[UIImageView alloc] init];
    sunImage1.image = [UIImage imageNamed:@"usersummary_icon_lv_sun"];
    sunImage1.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:sunImage1];
    [sunImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageV.mas_bottom).offset(5);
        make.left.equalTo(self.gradeImageV.mas_right);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    UIImageView *moonImage1 = [[UIImageView alloc] init];
    moonImage1.image = [UIImage imageNamed:@"usersummary_icon_lv_moon"];
    moonImage1.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:moonImage1];
    [moonImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.gradeImageV);
        make.left.equalTo(sunImage1.mas_right).offset(2);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    UIImageView *moonImage2 = [[UIImageView alloc] init];
    moonImage2.image = [UIImage imageNamed:@"usersummary_icon_lv_moon"];
    moonImage2.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:moonImage2];
    [moonImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.gradeImageV);
        make.left.equalTo(moonImage1.mas_right).offset(2);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    UIImageView *starImage1 = [[UIImageView alloc] init];
    starImage1.image = [UIImage imageNamed:@"usersummary_icon_lv_star"];
    starImage1.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:starImage1];
    [starImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.gradeImageV);
        make.left.equalTo(moonImage2.mas_right).offset(2);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    [self.personalizedSignatureBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.gradeImageV.mas_bottom).offset(10);
        make.left.equalTo(self.gradeImageV);
        make.height.mas_equalTo(15);
    }];
    //tableview
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headScrollview.mas_bottom).offset(20);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop).offset(-40);
    }];
    [self.view addSubview:self.settingBut];
    [self.settingBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.bottom.equalTo(self.view).offset(-15);
    }];
    [self.view addSubview:self.nightmodeoffBut];
    [self.nightmodeoffBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.settingBut.mas_right).offset(50);
        make.centerY.equalTo(self.settingBut);
    }];
    
    
}
- (void)QRCodeMethod{
    QRCodeViewController *QRCodeVC = [[QRCodeViewController alloc] init];
    //自己添加的导航栏默认没有返回按钮
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:QRCodeVC];
    QRCodeVC.delegate = self;
    [self presentViewController:nav animated:NO completion:nil];
}
#pragma mark - BackMessageVCWhenDismissRQCodeVCDelegate
- (void)backMessageVC{
    DDMenuController *ddMenu = (DDMenuController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [ddMenu showRootController:YES];
}
- (void)personalizedSignatureMethod{
    
}
//退出(暂无设置功能)
- (void)settingButAction:(UIButton *)sender{
    MBProgressHUD *hud = [MBProgressHUD showHUDMessage:@"正在退出..." addedTo:self.view autoHide:NO textOnly:NO];
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        [hud hideAnimated:YES];
        if (error && error.errorCode != EMErrorServerNotLogin) {
            [MBProgressHUD toastWithFailture:@"退出失败"];
        }else{
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            [self presentViewController:loginVC animated:YES completion:nil];            
        }
    } onQueue:nil];
}
//夜间
- (void)nightmodeoffButAction:(UIButton *)sender{
    
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sidebarIconList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"LeftViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//        cell.textLabel.text = @"退出登录";
////        cell.textLabel.textAlignment = NSTextAlignmentCenter;
//        cell.textLabel.textColor = [UIColor redColor];
    }
    NSString *iconStr = self.sidebarIconList[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:iconStr];
    cell.textLabel.text = self.sidebarNameList[indexPath.row];
//    cell.textLabel.textColor = [UIColor blackColor];
    return cell;
}
//scrollview自动滚动方法
- (void)scrollScrollView:(NSTimer *)timer{
    CGPoint newScrollViewContentOffset = self.headScrollview.contentOffset;
//    newScrollViewContentOffset.y = MAX(0, newScrollViewContentOffset.y);
    if (newScrollViewContentOffset.y == 0 || newScrollViewContentOffset.y > self.currenOffsetY) {
        self.currenOffsetY = newScrollViewContentOffset.y;
        //向上移动1pt
        newScrollViewContentOffset.y += 1;
        self.headScrollview.contentOffset = newScrollViewContentOffset;
    }
    //如果到顶了，scrollview向下滑动
    if (newScrollViewContentOffset.y == 280 || newScrollViewContentOffset.y < self.currenOffsetY) {
        self.currenOffsetY = newScrollViewContentOffset.y;
        //向下移动1pt
        newScrollViewContentOffset.y -= 1;
        self.headScrollview.contentOffset = newScrollViewContentOffset;
    }
    
    
}
#pragma mark subview
-(UIScrollView *)headScrollview{
    if (!_headScrollview) {
        _headScrollview = [[UIScrollView alloc] init];
        _headScrollview.scrollEnabled = NO;
        _headScrollview.bounces = NO;
    }
    return _headScrollview;
}
-(UIImageView *)bgImageV{
    if (!_bgImageV) {
        _bgImageV = [[UIImageView alloc] init];
        _bgImageV.image = [UIImage imageNamed:@"img_leftBackGround_3"];
        _bgImageV.contentMode = UIViewContentModeBottom;
    }
    return _bgImageV;
}
-(UIButton *)QRCodeBut{
    if (!_QRCodeBut) {
        _QRCodeBut = [[UIButton alloc] init];
        [_QRCodeBut setImage:[UIImage imageNamed:@"sidebar_QRcode_normal"] forState:UIControlStateNormal];
//        _QRCodeBut.alpha = 0.9;
        [_QRCodeBut addTarget:self action:@selector(QRCodeMethod) forControlEvents:UIControlEventTouchUpInside];
    }
    return _QRCodeBut;
}
-(UIImageView *)headImageV{
    if (!_headImageV) {
        _headImageV = [[UIImageView alloc] init];
        _headImageV.image = [UIImage imageNamed:@"head7_40x40"];
        _headImageV.layer.cornerRadius = 20;
        _headImageV.layer.masksToBounds = YES;
        _headImageV.layer.borderWidth = 1.5;
        _headImageV.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return _headImageV;
}
-(UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.text = @"幻光炫紫";
        _nameLab.textColor = [UIColor whiteColor];
        _nameLab.font = [UIFont boldSystemFontOfSize:34];
        //给label的文本添加阴影效果
        _nameLab.shadowColor = [UIColor grayColor];
        _nameLab.shadowOffset = CGSizeMake(0, -1);
    }
    return _nameLab;
}
-(UIImageView *)gradeImageV{
    if (!_gradeImageV) {
        _gradeImageV = [[UIImageView alloc] init];
        _gradeImageV.image = [UIImage imageNamed:@"usersummary_icon_lv_sun"];
        _gradeImageV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _gradeImageV;
}
-(UIButton *)personalizedSignatureBut{
    if (!_personalizedSignatureBut) {
        _personalizedSignatureBut = [[UIButton alloc] init];
        [_personalizedSignatureBut setTitle:@"two years" forState:UIControlStateNormal];
        [_personalizedSignatureBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _personalizedSignatureBut.titleLabel.shadowColor = [UIColor grayColor];
        _personalizedSignatureBut.titleLabel.shadowOffset = CGSizeMake(0, -2);
        [_personalizedSignatureBut addTarget:self action:@selector(personalizedSignatureMethod) forControlEvents:UIControlEventTouchUpInside];
    }
    return _personalizedSignatureBut;
}
-(NSTimer *)timer{
    return _timer;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
-(UIButton *)settingBut{
    if (!_settingBut) {
        _settingBut = [[UIButton alloc] init];
        [_settingBut setImage:[UIImage imageNamed:@"sidebar_setting_press"] forState:UIControlStateNormal];
        [_settingBut setTitle:@"退出" forState:UIControlStateNormal];
        [_settingBut setTitleColor:TEXTCOLOR forState:UIControlStateNormal];
        _settingBut.titleLabel.font = [UIFont systemFontOfSize:15];
        [_settingBut setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
        [_settingBut addTarget:self action:@selector(settingButAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingBut;
}
-(UIButton *)nightmodeoffBut{
    if (!_nightmodeoffBut) {
        _nightmodeoffBut = [[UIButton alloc] init];
        [_nightmodeoffBut setImage:[UIImage imageNamed:@"sidebar_nightmode_off"] forState:UIControlStateNormal];
        [_nightmodeoffBut setTitle:@"夜间" forState:UIControlStateNormal];
        [_nightmodeoffBut setTitleColor:TEXTCOLOR forState:UIControlStateNormal];
        _nightmodeoffBut.titleLabel.font = [UIFont systemFontOfSize:15];
        [_nightmodeoffBut setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
        [_nightmodeoffBut addTarget:self action:@selector(nightmodeoffButAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nightmodeoffBut;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
