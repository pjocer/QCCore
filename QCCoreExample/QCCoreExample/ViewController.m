//
//  ViewController.m
//  QCCoreExample
//
//  Created by XuQian on 1/16/16.
//  Copyright © 2016 qcwl. All rights reserved.
//

#import "ViewController.h"
#import <QCCore/QCCore.h>

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    NSData *data = UIImageJPEGRepresentation(image, 0.8);
    
//    QCAPIDataRequest *request = [[QCAPIDataRequest alloc] initWithAPIName:@"photo/upload" dataArray:@[data]];
//    [request uploadWithSuccessBlock:^(QCAPIDataRequest * _Nonnull request) {
//        DTrace();
//    } failedBlock:^(QCAPIDataRequest * _Nonnull request) {
//        DTrace();
//    }];
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
