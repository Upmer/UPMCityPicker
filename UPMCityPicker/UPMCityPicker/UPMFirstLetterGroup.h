//
//  UPMFirstLetterGroup.h
//  UPMCityPicker
//
//  Created by tsuf on 2018/11/1.
//  Copyright © 2018 upmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UPMCityInfo.h"

@interface UPMFirstLetterGroup : NSObject

@property (nonatomic, copy) NSString *firstLetter;
@property (nonatomic, copy) NSString *indexString;
@property (nonatomic, strong) NSArray<UPMCityInfo *> *cities;

+ (instancetype)groupWithDictionary:(NSDictionary *)dict;
+ (NSArray<UPMFirstLetterGroup *> *)groupsWithArray:(NSArray *)infos;

@end

