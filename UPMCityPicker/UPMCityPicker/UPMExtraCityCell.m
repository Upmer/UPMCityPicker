//
//  UPMExtraCityCell.m
//  UPMCityPicker
//
//  Created by tsuf on 2018/11/2.
//  Copyright © 2018 upmer. All rights reserved.
//

#import "UPMExtraCityCell.h"

@interface UPMExtraCityCell ()

@property (nonatomic, weak) UILabel *titleLabel;

@end

@implementation UPMExtraCityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UILabel *titleLabel = [[UILabel alloc] init];
    self.titleLabel = titleLabel;
    self.titleLabel.textColor = self.tintColor ?: UIColor.lightGrayColor;
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = [UIColor.lightGrayColor colorWithAlphaComponent:0.2];
    self.titleLabel.layer.cornerRadius = 5;
    titleLabel.clipsToBounds = YES;
    [self.contentView addSubview:titleLabel];
}

- (void)setName:(NSString *)name {
    _name = name;
    self.titleLabel.text = name;
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    if (tintColor) {
        self.titleLabel.textColor = tintColor;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = self.bounds;
}

@end
