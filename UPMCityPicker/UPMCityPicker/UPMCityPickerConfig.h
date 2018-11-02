//
//  UPMCityPickerConfig.h
//  UPMCityPicker
//
//  Created by tsuf on 2018/11/2.
//  Copyright © 2018 upmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UPMCityPickerConfig : NSObject

@property (nonatomic, strong) NSArray<NSString *> *hotCities;

@property (nonatomic, assign, getter=isUseLocation) BOOL useLocation;

@end
