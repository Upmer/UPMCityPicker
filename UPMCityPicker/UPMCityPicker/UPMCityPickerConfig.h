//
//  UPMCityPickerConfig.h
//  UPMCityPicker
//
//  Created by tsuf on 2018/11/2.
//  Copyright © 2018 upmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UPMCityPickerConfig : NSObject

@property (nonatomic, strong) NSArray<NSString *> *hotCities;

@property (nonatomic, assign, getter=isUseLocation) BOOL useLocation;

@property (nonatomic, strong) UIColor *tintColor;

@property (nonatomic, copy) NSString *navTitle;

@property (nonatomic, strong) UIView *backView;

@end
