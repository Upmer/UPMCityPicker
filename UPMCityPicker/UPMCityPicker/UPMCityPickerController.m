//
//  UPMCityPickerController.m
//  UPMCityPicker
//
//  Created by tsuf on 2018/11/1.
//  Copyright © 2018 upmer. All rights reserved.
//

#import "UPMCityPickerController.h"
#import "UPMFirstLetterGroup.h"

@interface UPMCityPickerController () <UITableViewDataSource, UITableViewDelegate>

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

- (void)prepareData {
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
            [self.tableView reloadData];
        });
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    tableView.rowHeight = 50;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.frame = self.view.bounds;
    [tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"cityCell"];
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
    tableView.tintColor = UIColor.blackColor;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cityGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *cities = self.cityGroups[section].cities;
    return cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell" forIndexPath:indexPath];
    NSArray<UPMCityInfo *> *cities = self.cityGroups[indexPath.section].cities;
    cell.textLabel.text = cities[indexPath.row].name;
    return cell;
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
    NSArray<UPMCityInfo *> *cities = self.cityGroups[indexPath.section].cities;
    [cities[indexPath.row] save];
}

@end
