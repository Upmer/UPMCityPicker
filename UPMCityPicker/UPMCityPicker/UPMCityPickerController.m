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
#import "UPMLocationHeaderView.h"
#import <CoreLocation/CoreLocation.h>

@interface UPMCityPickerController () <UITableViewDataSource, UITableViewDelegate, UPMExtraGroupCellDelegate, CLLocationManagerDelegate, UPMLocationHeaderViewDelegate>

@property (nonatomic, strong) UPMCityPickerConfig *config;

@property (nonatomic, strong) UPMLocationHeaderView *headerView;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray<UPMFirstLetterGroup *> *cityGroups;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *geocoder;

@property (nonatomic, assign) NSUInteger locationUpdateCount;

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

- (UPMLocationHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[UPMLocationHeaderView alloc] init];
        _headerView.delegate = self;
        _headerView.tintColor = self.config.tintColor;
        _headerView.frame = CGRectMake(0, 0, 0, 28 + 50);
    }
    return _headerView;
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
        
        // TODO: hot cities optimize
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
    
    self.title = self.config.navTitle;
    
    if (self.navigationController && self.config.backView) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.config.backView];
    }
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if (![CLLocationManager locationServicesEnabled] && !self.config.isUseLocation) {
        self.config.useLocation = NO;
    } else {
        if (status == kCLAuthorizationStatusNotDetermined) {
            [self.locationManager requestWhenInUseAuthorization];
        } else if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
            [self.locationManager startUpdatingLocation];
        }
    }
    
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.frame = self.view.bounds;
    [tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"cityCell"];
    [tableView registerClass:UPMExtraGroupCell.class forCellReuseIdentifier:@"extraCell"];
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
    tableView.tintColor = self.config.tintColor ?: UIColor.blackColor;
    
    if (self.config.isUseLocation) {
        tableView.tableHeaderView = self.headerView;
    }
    
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
        ((UPMExtraGroupCell *)cell).delegate = self;
        ((UPMExtraGroupCell *)cell).tintColor = self.config.tintColor;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell" forIndexPath:indexPath];
        NSArray<UPMCityInfo *> *cities = self.cityGroups[indexPath.section].cities;
        cell.textLabel.text = cities[indexPath.row].name;
        cell.textLabel.textColor = self.config.tintColor ?: UIColor.blackColor;
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
    if ([_delegate respondsToSelector:@selector(cityPickerController:didSelectedCityName:)]) {
        [_delegate cityPickerController:self didSelectedCityName:cities[indexPath.item].name];
    }
}

- (void)extraGroupCell:(UPMExtraGroupCell *)cell didSelectedCityName:(NSString *)city {
    if ([_delegate respondsToSelector:@selector(cityPickerController:didSelectedCityName:)]) {
        [_delegate cityPickerController:self didSelectedCityName:city];
    }
}

- (void)locationHeaderView:(UPMLocationHeaderView *)headerView didSelectedCityName:(NSString *)city {
    if ([_delegate respondsToSelector:@selector(cityPickerController:didSelectedCityName:)]) {
        [_delegate cityPickerController:self didSelectedCityName:city];
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        if (self.config.isUseLocation) {
            [manager startUpdatingLocation];
        }
    } else if (status == kCLAuthorizationStatusDenied) {
        self.config.useLocation = NO;
        self.tableView.tableHeaderView = [[UIView alloc] init];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    self.locationUpdateCount++;
    [manager stopUpdatingLocation];
    CLLocation *location = locations.firstObject;
    self.geocoder = [[CLGeocoder alloc] init];
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error || placemarks.count == 0) {
            if (self.locationUpdateCount >= 5) {
                self.headerView.name = @"定位错误";
                self.locationManager = nil;
            } else {
                [manager startUpdatingLocation];
            }
        } else {
            for (CLPlacemark *placemark in placemarks) {
                if (placemark.locality.length > 0) {
                    self.headerView.name = placemark.locality;
                    self.locationManager = nil;
                    return;
                }
            }
            [manager startUpdatingLocation];
        }
    }];
}

@end
