//
//  KXBuddyDynamicVC.m
//  kaixun
//
//  Created by 张凯 on 2018/5/22.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "KXBuddyDynamicVC.h"

@interface KXBuddyDynamicVC ()
@property (strong, nonatomic) UIWebView *webView;

@end

@implementation KXBuddyDynamicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleStr;
    [self.view addSubview:self.webView];
    [self configLayout];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://h5.qzone.qq.com/mqzone/index"]];
    [self.webView loadRequest:request];
}

#pragma mark - configLayout
- (void)configLayout{
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideTop);
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuideBottom);
        make.right.equalTo(self.view);
    }];
}
#pragma mark - gets/sets
- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]init];
        [_webView setScalesPageToFit:YES];
        _webView.backgroundColor = [UIColor clearColor];
    }
    return _webView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
