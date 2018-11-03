//
//  UPMExtraGroupCell.h
//  UPMCityPicker
//
//  Created by tsuf on 2018/11/2.
//  Copyright © 2018 upmer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UPMCityInfo;
@class UPMExtraGroupCell;

@protocol UPMExtraGroupCellDelegate <NSObject>

@optional
- (void)extraGroupCell:(UPMExtraGroupCell *)cell didSelectedCityName:(NSString *)city;

@end

NS_ASSUME_NONNULL_BEGIN

@interface UPMExtraGroupCell : UITableViewCell

@property (nonatomic, weak) id<UPMExtraGroupCellDelegate> delegate;

@property (nonatomic, strong) NSArray<UPMCityInfo *> *cities;

@property (nonatomic, strong) UIColor *tintColor;

@end

NS_ASSUME_NONNULL_END
