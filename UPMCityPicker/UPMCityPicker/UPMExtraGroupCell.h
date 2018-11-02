//
//  UPMExtraGroupCell.h
//  UPMCityPicker
//
//  Created by tsuf on 2018/11/2.
//  Copyright © 2018 upmer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UPMCityInfo;

NS_ASSUME_NONNULL_BEGIN

@interface UPMExtraGroupCell : UITableViewCell

@property (nonatomic, strong) NSArray<UPMCityInfo *> *cities;

@end

NS_ASSUME_NONNULL_END
