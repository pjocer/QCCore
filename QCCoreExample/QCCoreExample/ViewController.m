//
//  ViewController.m
//  QCCoreExample
//
//  Created by XuQian on 1/16/16.
//  Copyright © 2016 qcwl. All rights reserved.
//

#import "ViewController.h"
#import <QCCore/QCCore.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
    view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view];
    
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.borderWidth = 0;
    layer.frame = CGRectMake(0, 60, 100, 40);
    layer.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor blackColor].CGColor];
//    layer.locations = @[@0.5,@0.9,@1];
    layer.startPoint = CGPointMake(0, 0.5);
    layer.endPoint = CGPointMake(1, 0.5);
    [view.layer addSublayer:layer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    QCDebugController *controller = [[QCDebugController alloc] init];
//    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:controller];
//    [self presentViewController:navi animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
