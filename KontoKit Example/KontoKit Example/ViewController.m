//
//  ViewController.m
//  KontoKit Example
//
//  Created by Kashif Rasul on 6/23/13.
//  Copyright (c) 2013 Kashif Rasul. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.kontoView = [[KKView alloc] initWithFrame:CGRectMake(15, 25, 290, 45)];
    self.kontoView.delegate = self;
    
    [self.view addSubview:self.kontoView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
