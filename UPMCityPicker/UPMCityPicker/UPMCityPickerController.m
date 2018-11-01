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
    return group.firstLetter;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *titles = [NSMutableArray array];
    for (UPMFirstLetterGroup *group in self.cityGroups) {
        [titles addObject:group.firstLetter.uppercaseString];
    }
    return [NSArray arrayWithArray:titles];
}

@end
