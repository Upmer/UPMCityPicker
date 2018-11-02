//
//  UPMCityPickerController.h
//  UPMCityPicker
//
//  Created by tsuf on 2018/11/1.
//  Copyright © 2018 upmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPMCityPickerConfig.h"
@class UPMCityPickerController;

@protocol UPMCityPickerControllerDelegate <NSObject>

@optional
- (void)cityPickerController:(UPMCityPickerController *)picker didSelectedCityName:(NSString *)city;

@end

NS_ASSUME_NONNULL_BEGIN

@interface UPMCityPickerController : UIViewController

- (instancetype)initWithConfig:(UPMCityPickerConfig *)config;

@end

NS_ASSUME_NONNULL_END
