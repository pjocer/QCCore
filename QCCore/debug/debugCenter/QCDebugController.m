//
//  QCDebugController.m
//  QCCore
//
//  Created by XuQian on 1/20/16.
//  Copyright © 2016 qcwl. All rights reserved.
//

#import "QCDebugController.h"
#import "QCAPIRequest.h"
#import "DebugManager.h"
#import "QCDebugInfoController.h"
#import "QCDebugAnnoSelectController.h"

@interface QCDebugController () <UIAlertViewDelegate, UIActionSheetDelegate>

@end

@implementation QCDebugController

- (id)init
{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.title = @"调试工具";
    self.view.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = @"API";
        cell.detailTextLabel.text = [QCAPIRequest currentDomain];
    }else {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"信息采集";
        }else if (indexPath.row == 1) {
            cell.textLabel.text = @"定位坐标切换";
        }else {
            cell.textLabel.text = @"崩溃日志";
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"API" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"正式" otherButtonTitles:@"试用", @"预发布", @"测试", @"开发", @"自定义", nil];
        [sheet showInView:self.view];
    }else {
        UIViewController *controller;
        if (indexPath.row == 0) {
            controller = [[QCDebugInfoController alloc] initWithStyle:UITableViewStyleGrouped];
        }else if (indexPath.row == 1) {
            controller = [[QCDebugAnnoSelectController alloc] init];
        }
        
        if (controller) [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [DebugManager manager].customDomain = @"http://api.qccost.com/";
    }else if (buttonIndex == 1) {
        [QCAPIRequest setAPIMode:TrialAPI];
        [QCAPIRequest currentDomain];
    }else if (buttonIndex == 2) {
        [DebugManager manager].customDomain = @"http://dev.qccost.com/api/";
    }else if (buttonIndex == 3) {
        [DebugManager manager].customDomain = @"http://api.qa.fk.com/";
    }else if (buttonIndex == 4) {
        [DebugManager manager].customDomain = @"http://dev.fk.com/api/";
    }else if (buttonIndex == 5) {
        UIAlertView *alert = [[UIAlertView alloc] init];
        alert.delegate = self;
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        alert.title = @"input domain";
        [alert addButtonWithTitle:@"confirm"];
        [alert addButtonWithTitle:@"cancel"];
        [alert show];
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        [DebugManager manager].customDomain = textField ? textField.text : @"";
        [textField resignFirstResponder];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end
