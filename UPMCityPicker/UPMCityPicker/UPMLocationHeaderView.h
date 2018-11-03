//
//  UPMLocationHeaderView.h
//  UPMCityPicker
//
//  Created by tsuf on 2018/11/2.
//  Copyright © 2018 upmer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UPMLocationHeaderView;

@protocol UPMLocationHeaderViewDelegate <NSObject>

@optional
- (void)locationHeaderView:(UPMLocationHeaderView *)headerView didSelectedCityName:(NSString *)city;

@end

NS_ASSUME_NONNULL_BEGIN

@interface UPMLocationHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak) id<UPMLocationHeaderViewDelegate> delegate;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) UIColor *tintColor;

@end

NS_ASSUME_NONNULL_END
