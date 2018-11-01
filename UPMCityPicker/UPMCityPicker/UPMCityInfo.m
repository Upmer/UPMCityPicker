//
//  UPMCityInfo.m
//  UPMCityPicker
//
//  Created by tsuf on 2018/11/1.
//  Copyright © 2018 upmer. All rights reserved.
//

#import "UPMCityInfo.h"

@implementation UPMCityInfo

+ (NSArray<UPMCityInfo *> *)cityInfosWithArray:(NSArray *)infos {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in infos) {
        UPMCityInfo *info = [[UPMCityInfo alloc] initWithDictionary:dict];
        [array addObject:info];
    }
    return [NSArray arrayWithArray:array];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.ID = dict[@"id"];
        self.name = dict[@"name"];
        self.pid = dict[@"pid"];
        self.spell = dict[@"spell"];
    }
    return self;
}

@end
