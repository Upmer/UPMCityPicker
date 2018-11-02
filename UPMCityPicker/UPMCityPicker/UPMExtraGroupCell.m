//
//  UPMExtraGroupCell.m
//  UPMCityPicker
//
//  Created by tsuf on 2018/11/2.
//  Copyright © 2018 upmer. All rights reserved.
//

#import "UPMExtraGroupCell.h"
#import "UPMCityInfo.h"
#import "UPMExtraCityCell.h"

@interface UPMExtraGroupCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;

@end

@implementation UPMExtraGroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupCollectionView];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCollectionView];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupCollectionView];
    }
    return self;
}

- (void)setupCollectionView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat margin = 10;
    CGFloat w = (screenW - margin * 4) / 3;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = 10;
    layout.itemSize = CGSizeMake(w, 30);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView = collectionView;
    collectionView.backgroundColor = UIColor.whiteColor;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.contentInset = UIEdgeInsetsMake(margin, margin, margin, margin);
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.scrollEnabled = NO;
    [collectionView registerClass:UPMExtraCityCell.class forCellWithReuseIdentifier:@"extraCityCell"];
    [self addSubview:collectionView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

- (void)setCities:(NSArray<UPMCityInfo *> *)cities {
    _cities = cities;
    [self.collectionView reloadData];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cities.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UPMExtraCityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"extraCityCell" forIndexPath:indexPath];
    cell.name = self.cities[indexPath.item].name;
    return cell;
}

@end
