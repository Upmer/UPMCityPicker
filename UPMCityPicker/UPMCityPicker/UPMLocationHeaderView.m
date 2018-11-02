//
//  UPMLocationHeaderView.m
//  UPMCityPicker
//
//  Created by tsuf on 2018/11/2.
//  Copyright © 2018 upmer. All rights reserved.
//

#import "UPMLocationHeaderView.h"

@interface UPMLocationHeaderView ()

@property (nonatomic, weak) UIView *topView;
@property (nonatomic, weak) UILabel *descLabel;
@property (nonatomic, weak) UIButton *titleLabel;

@end

@implementation UPMLocationHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    UIView *topView = [[UIView alloc] init];
    self.topView = topView;
    topView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    [self.contentView addSubview:topView];
    
    UILabel *descLabel = [[UILabel alloc] init];
    self.descLabel = descLabel;
    descLabel.textColor = [UIColor colorWithRed:0.14 green:0.14 blue:0.14 alpha:1];
    descLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
    descLabel.layer.cornerRadius = 5;
    descLabel.clipsToBounds = YES;
    descLabel.text = @"定位城市";
    [self.topView addSubview:descLabel];
    
    UIButton *titleLabel = [[UIButton alloc] init];
    self.titleLabel = titleLabel;
    [titleLabel setTitleColor:UIColor.lightGrayColor forState:UIControlStateNormal];
    titleLabel.titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.backgroundColor = [UIColor.lightGrayColor colorWithAlphaComponent:0.2];
    titleLabel.layer.cornerRadius = 5;
    titleLabel.clipsToBounds = YES;
    titleLabel.adjustsImageWhenHighlighted = NO;
    [titleLabel addTarget:self action:@selector(onClick) forControlEvents:UIControlStateNormal];
    [self.contentView addSubview:titleLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.topView.frame = CGRectMake(0, 0, self.bounds.size.width, 28);
    self.descLabel.frame = CGRectMake(15, 4, self.topView.bounds.size.width, 20);
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat margin = 10;
    CGFloat w = (screenW - margin * 4) / 3;
    self.titleLabel.frame = CGRectMake(10, CGRectGetMaxY(self.topView.frame) + 10, w, 30);
}

- (void)onClick {
    if ([_delegate respondsToSelector:@selector(locationHeaderView:didSelectedCityName:)]) {
        [_delegate locationHeaderView:self didSelectedCityName:self.titleLabel.currentTitle];
    }
}

@end
