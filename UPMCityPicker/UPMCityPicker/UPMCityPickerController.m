//
//  UPMCityPickerController.m
//  UPMCityPicker
//
//  Created by tsuf on 2018/11/1.
//  Copyright © 2018 upmer. All rights reserved.
//

#import "UPMCityPickerController.h"
#import "UPMFirstLetterGroup.h"
#import "UPMExtraGroupCell.h"

@interface UPMCityPickerController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UPMCityPickerConfig *config;

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray<UPMFirstLetterGroup *> *cityGroups;

@end

@implementation UPMCityPickerController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self prepareData];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self prepareData];
    }
    return self;
}

- (instancetype)initWithConfig:(UPMCityPickerConfig *)config {
    if (self = [super init]) {
        _config = config;
        [self prepareData];
    }
    return self;
}

- (void)prepareData {
    NSLog(@"---");
    dispatch_queue_t queue = dispatch_queue_create("com.upmer.citypicker", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"UPMCityPicker.bundle"]];
        NSString *path = [bundle pathForResource:@"City" ofType:@"plist"];
        NSArray *sourceArray = [NSArray arrayWithContentsOfFile:path];
        
        NSMutableArray *modelGroups = [NSMutableArray arrayWithArray:[UPMFirstLetterGroup groupsWithArray:sourceArray]];
        NSMutableArray *groups = [NSMutableArray arrayWithArray:modelGroups];
        for (UPMFirstLetterGroup *group in modelGroups) {
            if (group.cities.count == 0) {
                [groups removeObject:group];
            }
        }
        
        // hot cities
        NSMutableArray *hotCities = [NSMutableArray array];
        if (self.config.hotCities.count > 0) {
            for (UPMFirstLetterGroup *group in groups) {
                for (UPMCityInfo *info in group.cities) {
                    if ([self.config.hotCities containsObject:info.name]) {
                        [hotCities addObject:info];
                    }
                    
                }
            }
            if (hotCities.count > 0) {
                UPMFirstLetterGroup *hotGroup = [[UPMFirstLetterGroup alloc] init];
                hotGroup.firstLetter = NSLocalizedString(@"热门城市", nil);
                hotGroup.indexString = NSLocalizedString(@"热门", nil);
                hotGroup.cities = [NSArray arrayWithArray:hotCities];
                [groups insertObject:hotGroup atIndex:0];
            }
        }
        
        // history cities
        NSArray<UPMCityInfo *> *historyCities = [UPMCityInfo historyCities];
        if (historyCities && historyCities.count > 0) {
            UPMFirstLetterGroup *historyGroup = [[UPMFirstLetterGroup alloc] init];
            historyGroup.firstLetter = NSLocalizedString(@"历史访问城市", nil);
            historyGroup.indexString = NSLocalizedString(@"历史", nil);
            historyGroup.cities = historyCities;
            [groups insertObject:historyGroup atIndex:0];
        }
        
        self.cityGroups = [NSArray arrayWithArray:groups];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"---");
            [self.tableView reloadData];
        });
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.frame = self.view.bounds;
    [tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"cityCell"];
    [tableView registerClass:UPMExtraGroupCell.class forCellReuseIdentifier:@"extraCell"];
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
    tableView.tintColor = UIColor.blackColor;
    
    if (self.navigationController == nil || self.navigationController.navigationBarHidden) {
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cityGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    UPMFirstLetterGroup *group = self.cityGroups[section];
    if (group.indexString.length > 0) {
        return 1;
    } else {
        NSArray *cities = self.cityGroups[section].cities;
        return cities.count;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    UPMFirstLetterGroup *group = self.cityGroups[indexPath.section];
    if (group.indexString.length > 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"extraCell" forIndexPath:indexPath];
        ((UPMExtraGroupCell *)cell).cities = group.cities;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell" forIndexPath:indexPath];
        NSArray<UPMCityInfo *> *cities = self.cityGroups[indexPath.section].cities;
        cell.textLabel.text = cities[indexPath.row].name;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UPMFirstLetterGroup *group = self.cityGroups[indexPath.section];
    if (group.indexString.length > 0) {
        int count = (int)group.cities.count / 3;
        if (group.cities.count % 3 != 0) {
            count++;
        }
        CGFloat margin = 10;
        return (30 + margin) * count + margin;
    }
    return 50;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    UPMFirstLetterGroup *group = self.cityGroups[section];
    return group.firstLetter.uppercaseString;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *titles = [NSMutableArray array];
    for (UPMFirstLetterGroup *group in self.cityGroups) {
        NSString *indexString = group.firstLetter.uppercaseString;
        if (group.indexString.length > 0) {
            indexString = group.indexString;
        }
        [titles addObject:indexString];
    }
    return [NSArray arrayWithArray:titles];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSArray<UPMCityInfo *> *cities = self.cityGroups[indexPath.section].cities;
    [cities[indexPath.row] save];
}

@end
