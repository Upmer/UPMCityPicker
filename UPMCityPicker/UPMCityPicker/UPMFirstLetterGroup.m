//
//  UPMFirstLetterGroup.m
//  UPMCityPicker
//
//  Created by tsuf on 2018/11/1.
//  Copyright © 2018 upmer. All rights reserved.
//

#import "UPMFirstLetterGroup.h"

@implementation UPMFirstLetterGroup

+ (NSArray<UPMFirstLetterGroup *> *)groupsWithArray:(NSArray *)infos {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in infos) {
        [array addObject:[UPMFirstLetterGroup groupWithDictionary:dict]];
    }
    return [NSArray arrayWithArray:array];
}

+ (instancetype)groupWithDictionary:(NSDictionary *)dict {
    UPMFirstLetterGroup *group = [[UPMFirstLetterGroup alloc] init];
    group.firstLetter = dict[@"letter"];
    group.cities = [UPMCityInfo cityInfosWithArray:dict[@"cities"]];
    return group;
}

@end
