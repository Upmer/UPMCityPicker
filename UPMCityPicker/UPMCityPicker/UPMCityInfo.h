//
//  UPMCityInfo.h
//  UPMCityPicker
//
//  Created by tsuf on 2018/11/1.
//  Copyright © 2018 upmer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UPMCityInfo : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *spell;

@property (nonatomic, strong) NSArray<UPMCityInfo *> *childCities;

+ (NSArray<UPMCityInfo *> *)cityInfosWithArray:(NSArray *)infos;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

- (void)save;

@end

NS_ASSUME_NONNULL_END
