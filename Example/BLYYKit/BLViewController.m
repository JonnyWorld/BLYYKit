//
//  BLViewController.m
//  BLYYKit
//
//  Created by baozhou on 01/27/2021.
//  Copyright (c) 2021 baozhou. All rights reserved.
//

#import "BLViewController.h"
#import <YYKit/YYKit.h>

@interface BLViewController ()

@end

@implementation BLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    YYLabel *labe = [[YYLabel alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    labe.backgroundColor = UIColor.redColor;
    [self.view addSubview:labe];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
