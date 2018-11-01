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

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.pid forKey:@"pid"];
    [aCoder encodeObject:self.spell forKey:@"spell"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _ID = [aDecoder decodeObjectForKey:@"ID"];
        _name = [aDecoder decodeObjectForKey:@"name"];
        _pid = [aDecoder decodeObjectForKey:@"pid"];
        _spell = [aDecoder decodeObjectForKey:@"spell"];
    }
    return self;
}

- (void)save {
    NSArray *histories = [UPMCityInfo historyCities];
    NSMutableArray *array = [NSMutableArray array];
    
    if (histories) {
        array = [NSMutableArray arrayWithArray:histories];
    }
    
    for (NSUInteger i = 0; i < array.count; i++) {
        UPMCityInfo *info = array[i];
        
    }
    for (UPMCityInfo *info in histories) { // sent exist city to first
        if ([info.name isEqualToString:self.name]) {
            [array removeObject:info];
            [array insertObject:info atIndex:0];
            [NSKeyedArchiver archiveRootObject:array toFile:[UPMCityInfo cachePath]];
            return;
        }
    }
    
    int maxCount = 3;
    if (array.count >= maxCount) {
        [array removeObjectsInRange:NSMakeRange(2, array.count - maxCount + 1)];
    }
    [array insertObject:self atIndex:0];
    [NSKeyedArchiver archiveRootObject:array toFile:[UPMCityInfo cachePath]];
}

+ (NSArray<UPMCityInfo *> *)historyCities {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[UPMCityInfo cachePath]];
}

+ (NSString *)cachePath {
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"upmer_date_picker"];
    BOOL isDirectory = YES;
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:directory isDirectory:&isDirectory]) {
        [fm createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [directory stringByAppendingPathComponent:@"history"];
}

@end
