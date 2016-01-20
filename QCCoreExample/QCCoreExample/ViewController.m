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
