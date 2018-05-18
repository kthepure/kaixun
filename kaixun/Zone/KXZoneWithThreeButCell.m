//
//  KXZoneWithThreeButCell.m
//  kaixun
//
//  Created by 张凯 on 2018/5/18.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#define kLineWidth 0.5
#import "KXZoneWithThreeButCell.h"

@interface KXZoneWithThreeButCell ()

@property (strong, nonatomic) UIImageView *bannerIV;
@property (strong, nonatomic) UIButton *helperBtn;
@property (strong, nonatomic) UIButton *callPhoneBtn;
@property (strong, nonatomic) UIButton *requireServiceBtn;
@property (strong, nonatomic) UIView *verticalLine1View;
@property (strong, nonatomic) UIView *verticalLine2View;

@end

@implementation KXZoneWithThreeButCell

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass([self class]);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

#pragma mark - Override

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Method Private
- (void)setup
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    [self.contentView addSubview:self.bannerIV];
    [self.contentView addSubview:self.requireServiceBtn];
    [self.contentView addSubview:self.helperBtn];
    [self.contentView addSubview:self.callPhoneBtn];
    [self.contentView addSubview:self.verticalLine1View];
    [self.contentView addSubview:self.verticalLine2View];
    
    [self.bannerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.equalTo(self.contentView);
        make.height.mas_equalTo(CGRectGetHeight(self.bannerIV.frame));
    }];
    
    [self.requireServiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bannerIV.mas_bottom);
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(self.requireServiceBtn.mas_width);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView).dividedBy(3);
    }];
    
    [self.helperBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bannerIV.mas_bottom);
        make.height.equalTo(self.requireServiceBtn);
        make.left.equalTo(self.requireServiceBtn.mas_right);
        make.right.equalTo(self.contentView).multipliedBy(2.f/3.f);
    }];
    
    [self.callPhoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.helperBtn);
        make.height.equalTo(self.helperBtn);
        make.left.equalTo(self.helperBtn.mas_right);
        make.right.equalTo(self.contentView);
    }];
    
    [self.verticalLine1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.requireServiceBtn);
        make.width.mas_equalTo(kLineWidth);
        make.centerX.equalTo(self.requireServiceBtn.mas_right);
    }];
    
    [self.verticalLine2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.requireServiceBtn);
        make.width.mas_equalTo(kLineWidth);
        make.centerX.equalTo(self.helperBtn.mas_right);
    }];
}

- (void)adjustButton:(UIButton *)btn
{
    // 1. 得到imageView和titleLabel的宽、高
    CGFloat imageWith = btn.currentImage.size.width;
    CGFloat imageHeight = btn.currentImage.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        labelWidth = btn.titleLabel.intrinsicContentSize.width;
        labelHeight = btn.titleLabel.intrinsicContentSize.height;
    } else {
        labelWidth = btn.titleLabel.frame.size.width;
        labelHeight = btn.titleLabel.frame.size.height;
    }
    
    CGFloat space = 16;
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
    // 4. 赋值
    btn.titleEdgeInsets = labelEdgeInsets;
    btn.imageEdgeInsets = imageEdgeInsets;
}

#pragma mark - Event Response
- (void)askForHelperEvent:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(healthyServiceHelpWayCellWillAskingForHelper:)]) {
        [self.delegate healthyServiceHelpWayCellWillAskingForHelper:self];
    }
}

- (void)callPhoneEvent:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(healthyServiceHelpWayCellWillCallingPhone:)]) {
        [self.delegate healthyServiceHelpWayCellWillCallingPhone:self];
    }
}

- (void)requireServiceEvent:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(healthyServiceHelpWayCellWillRequireService:)]) {
        [self.delegate healthyServiceHelpWayCellWillRequireService:self];
    }
}

#pragma mark - Lazy Load

- (UIImageView *)bannerIV
{
    if (!_bannerIV) {
        _bannerIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"s201_banner"]];
        [_bannerIV setContentMode:UIViewContentModeScaleAspectFit];
        CGSize imageSize = _bannerIV.image.size;
        CGSize viewSize = [UIScreen mainScreen].bounds.size;
        
        CGFloat actualHeight = viewSize.width / imageSize.width * imageSize.height;
        [_bannerIV setBounds:CGRectMake(0, 0, viewSize.width, actualHeight)];
    }
    return _bannerIV;
}

- (UIView *)verticalLine1View
{
    if (!_verticalLine1View) {
        _verticalLine1View = [UIView new];
        [_verticalLine1View setBackgroundColor:[UIColor colorWithDecimalRed:224 green:227 blue:233 alpha:1]];
    }
    return _verticalLine1View;
}

- (UIView *)verticalLine2View
{
    if (!_verticalLine2View) {
        _verticalLine2View = [UIView new];
        [_verticalLine2View setBackgroundColor:[UIColor colorWithDecimalRed:224 green:227 blue:233 alpha:1]];
    }
    return _verticalLine2View;
}

- (UIButton *)helperBtn
{
    if (!_helperBtn) {
        _helperBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_helperBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_helperBtn.titleLabel setNumberOfLines:0];
        
        [_helperBtn setImage:[UIImage imageNamed:@"s201_icon_help"] forState:UIControlStateNormal];
        
        NSString *title = @"向助手发求助";
        NSString *subtitle = @"柳叶助手帮您解决";
        NSString *combineTitle = [NSString stringWithFormat:@"%@\n%@", title, subtitle];
        NSRange titleRange = [combineTitle rangeOfString:title];
        NSRange subtitleRange = [combineTitle rangeOfString:subtitle];
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:combineTitle];
        [attr addAttributes:@{
                              NSForegroundColorAttributeName : [UIColor colorWithDecimalRed:64 green:74 blue:84 alpha:1],
                              NSFontAttributeName : [UIFont boldSystemFontOfSize:15]} range:titleRange];
        [attr addAttributes:@{
                              NSForegroundColorAttributeName : [UIColor colorWithDecimalRed:170 green:178 blue:189 alpha:1], NSFontAttributeName : [UIFont systemFontOfSize:12]} range:subtitleRange];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        [paragraphStyle setLineSpacing:5.f];
        [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [combineTitle length])];
        [_helperBtn setAttributedTitle:attr forState:UIControlStateNormal];
        
        [_helperBtn addTarget:self action:@selector(askForHelperEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        [self adjustButton:self.helperBtn];
    }
    return _helperBtn;
}

- (UIButton *)callPhoneBtn
{
    if (!_callPhoneBtn) {
        _callPhoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_callPhoneBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_callPhoneBtn.titleLabel setNumberOfLines:0];
        
        [_callPhoneBtn setImage:[UIImage imageNamed:@"s201_icon_400"] forState:UIControlStateNormal];
        
        NSString *title = @"400服务热线";
        NSString *subtitle = @"专业个性化服务";
        NSString *combineTitle = [NSString stringWithFormat:@"%@\n%@", title, subtitle];
        NSRange titleRange = [combineTitle rangeOfString:title];
        NSRange subtitleRange = [combineTitle rangeOfString:subtitle];
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:combineTitle];
        [attr addAttributes:@{
                              NSForegroundColorAttributeName : [UIColor colorWithDecimalRed:67 green:74 blue:84 alpha:1],
                              NSFontAttributeName : [UIFont boldSystemFontOfSize:15]} range:titleRange];
        [attr addAttributes:@{
                              NSForegroundColorAttributeName : [UIColor colorWithDecimalRed:170 green:178 blue:189 alpha:1], NSFontAttributeName : [UIFont systemFontOfSize:12]} range:subtitleRange];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        [paragraphStyle setLineSpacing:5.f];
        [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [combineTitle length])];
        [_callPhoneBtn setAttributedTitle:attr forState:UIControlStateNormal];
        
        [_callPhoneBtn addTarget:self action:@selector(callPhoneEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        [self adjustButton:self.callPhoneBtn];
    }
    return _callPhoneBtn;
}

- (UIButton *)requireServiceBtn
{
    if (!_requireServiceBtn) {
        _requireServiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_requireServiceBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_requireServiceBtn.titleLabel setNumberOfLines:0];
        
        [_requireServiceBtn setImage:[UIImage imageNamed:@"s201_icon_service"] forState:UIControlStateNormal];
        
        NSString *title = @"寻找贴心服务";
        NSString *subtitle = @"服务精心呈现";
        NSString *combineTitle = [NSString stringWithFormat:@"%@\n%@", title, subtitle];
        NSRange titleRange = [combineTitle rangeOfString:title];
        NSRange subtitleRange = [combineTitle rangeOfString:subtitle];
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:combineTitle];
        [attr addAttributes:@{
                              NSForegroundColorAttributeName : [UIColor colorWithDecimalRed:67 green:74 blue:84 alpha:1],
                              NSFontAttributeName : [UIFont boldSystemFontOfSize:15]} range:titleRange];
        [attr addAttributes:@{
                              NSForegroundColorAttributeName : [UIColor colorWithDecimalRed:170 green:178 blue:189 alpha:1], NSFontAttributeName : [UIFont systemFontOfSize:12]} range:subtitleRange];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        [paragraphStyle setLineSpacing:5.f];
        [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [combineTitle length])];
        [_requireServiceBtn setAttributedTitle:attr forState:UIControlStateNormal];
        
        [_requireServiceBtn addTarget:self action:@selector(requireServiceEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        [self adjustButton:self.requireServiceBtn];
    }
    return _requireServiceBtn;
}


@end
