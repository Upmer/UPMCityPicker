//
//  ViewController.m
//  UPMCityPicker
//
//  Created by tsuf on 2018/11/1.
//  Copyright © 2018 upmer. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

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


@end
