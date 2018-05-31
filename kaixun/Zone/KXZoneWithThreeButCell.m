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

@property (strong, nonatomic) UIButton *nearbyBtn;
@property (strong, nonatomic) UIButton *intersetTribesBtn;
@property (strong, nonatomic) UIButton *buddyDynamicsBtn;
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
    
    [self.contentView addSubview:self.buddyDynamicsBtn];
    [self.contentView addSubview:self.nearbyBtn];
    [self.contentView addSubview:self.intersetTribesBtn];
    [self.contentView addSubview:self.verticalLine1View];
    [self.contentView addSubview:self.verticalLine2View];
    
    [self.buddyDynamicsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(self.buddyDynamicsBtn.mas_width);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView).dividedBy(3);
    }];
    
    [self.nearbyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.height.equalTo(self.buddyDynamicsBtn);
        make.left.equalTo(self.buddyDynamicsBtn.mas_right);
        make.right.equalTo(self.contentView).multipliedBy(2.f/3.f);
    }];
    
    [self.intersetTribesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nearbyBtn);
        make.height.equalTo(self.nearbyBtn);
        make.left.equalTo(self.nearbyBtn.mas_right);
        make.right.equalTo(self.contentView);
    }];
    
    //去除两个竖直的间隔线
//    [self.verticalLine1View mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.equalTo(self.buddyDynamicsBtn);
//        make.width.mas_equalTo(kLineWidth);
//        make.centerX.equalTo(self.buddyDynamicsBtn.mas_right);
//    }];
//
//    [self.verticalLine2View mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.equalTo(self.buddyDynamicsBtn);
//        make.width.mas_equalTo(kLineWidth);
//        make.centerX.equalTo(self.nearbyBtn.mas_right);
//    }];
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
- (void)buddyDynamicsEvent:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(zoneBuddyDynamicsDelegate:)]) {
        [self.delegate zoneBuddyDynamicsDelegate:@"好友动态"];
    }
}

- (void)nearbyEvent:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(zoneNearbyDelegate)]) {
        [self.delegate zoneNearbyDelegate];
    }
}
- (void)intersetTribesEvent:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(zoneIntersetTribesDelegate)]) {
        [self.delegate zoneIntersetTribesDelegate];
    }
}

#pragma mark - Lazy Load

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

- (UIButton *)nearbyBtn
{
    if (!_nearbyBtn) {
        _nearbyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nearbyBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_nearbyBtn.titleLabel setNumberOfLines:0];
        
        [_nearbyBtn setImage:[UIImage imageNamed:@"found_icons_location"] forState:UIControlStateNormal];
        
        NSString *title = @"附近";
        NSRange titleRange = [title rangeOfString:title];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:title];
        [attr addAttributes:@{
                              NSForegroundColorAttributeName : [UIColor colorWithDecimalRed:64 green:74 blue:84 alpha:1],
                              NSFontAttributeName : [UIFont boldSystemFontOfSize:15]} range:titleRange];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        [paragraphStyle setLineSpacing:5.f];
        [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [title length])];
        [_nearbyBtn setAttributedTitle:attr forState:UIControlStateNormal];
        
        [_nearbyBtn addTarget:self action:@selector(nearbyEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        [self adjustButton:self.nearbyBtn];
    }
    return _nearbyBtn;
}

- (UIButton *)intersetTribesBtn
{
    if (!_intersetTribesBtn) {
        _intersetTribesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_intersetTribesBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_intersetTribesBtn.titleLabel setNumberOfLines:0];
        
        [_intersetTribesBtn setImage:[UIImage imageNamed:@"found_icons_group_buluo"] forState:UIControlStateNormal];
        
        NSString *title = @"兴趣部落";
        NSRange titleRange = [title rangeOfString:title];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:title];
        [attr addAttributes:@{
                              NSForegroundColorAttributeName : [UIColor colorWithDecimalRed:67 green:74 blue:84 alpha:1],
                              NSFontAttributeName : [UIFont boldSystemFontOfSize:15]} range:titleRange];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        [paragraphStyle setLineSpacing:5.f];
        [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [title length])];
        [_intersetTribesBtn setAttributedTitle:attr forState:UIControlStateNormal];
        
        [_intersetTribesBtn addTarget:self action:@selector(intersetTribesEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        [self adjustButton:self.intersetTribesBtn];
    }
    return _intersetTribesBtn;
}

- (UIButton *)buddyDynamicsBtn
{
    if (!_buddyDynamicsBtn) {
        _buddyDynamicsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buddyDynamicsBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_buddyDynamicsBtn.titleLabel setNumberOfLines:0];
        
        [_buddyDynamicsBtn setImage:[UIImage imageNamed:@"found_icons_qzone"] forState:UIControlStateNormal];
        
        NSString *title = @"好友动态";
        NSRange titleRange = [title rangeOfString:title];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:title];
        [attr addAttributes:@{
                              NSForegroundColorAttributeName : [UIColor colorWithDecimalRed:67 green:74 blue:84 alpha:1],
                              NSFontAttributeName : [UIFont boldSystemFontOfSize:15]} range:titleRange];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        [paragraphStyle setLineSpacing:5.f];
        [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [title length])];
        [_buddyDynamicsBtn setAttributedTitle:attr forState:UIControlStateNormal];
        
        [_buddyDynamicsBtn addTarget:self action:@selector(buddyDynamicsEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        [self adjustButton:self.buddyDynamicsBtn];
    }
    return _buddyDynamicsBtn;
}


@end
