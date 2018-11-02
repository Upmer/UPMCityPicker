//
//  ViewController.m
//  UPMCityPicker
//
//  Created by tsuf on 2018/11/1.
//  Copyright © 2018 upmer. All rights reserved.
//

#import "ViewController.h"
#import "UPMCityPickerController.h"

@interface ViewController () <UPMCityPickerControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *a = @"a";
    int aCode = [a characterAtIndex:0];
    NSLog(@"%d", aCode);
    NSLog(@"%@", [NSString stringWithFormat:@"%c", aCode + 1]);
    
}

- (IBAction)onOpenPicker:(id)sender {
    UPMCityPickerConfig *config = [[UPMCityPickerConfig alloc] init];
    config.hotCities = @[@"北京", @"上海", @"广州", @"深圳", @"杭州", @"成都"];
    UPMCityPickerController *picker = [[UPMCityPickerController alloc] initWithConfig:config];
    picker.delegate = self;
    [self.navigationController pushViewController:picker animated:YES];
}

- (void)cityPickerController:(UPMCityPickerController *)picker didSelectedCityName:(NSString *)city {
    NSLog(@"%@", city);
    [picker.navigationController popViewControllerAnimated:YES];
}

@end
