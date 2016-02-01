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
#import "QCDebugCrashListController.h"
#import "QCDebugLogo.h"

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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"在用户登录环境下，请勿切换API";
    }
    return nil;
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
        cell.detailTextLabel.text = QCCurrentDomain().domain;
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
        UIActionSheet *sheet = [[UIActionSheet alloc] init];
        [sheet setTitle:@"APIDomain"];
        for (int i=0; i<[DebugManager manager].domains.count; i++) {
            [sheet addButtonWithTitle:[DebugManager manager].domains[i].title];
        }
        [sheet addButtonWithTitle:@"自定义"];
        [sheet addButtonWithTitle:@"取消"];
        sheet.delegate = self;
        [sheet showInView:self.view];
    }else {
        UIViewController *controller;
        if (indexPath.row == 0) {
            controller = [[QCDebugInfoController alloc] initWithStyle:UITableViewStyleGrouped];
        }else if (indexPath.row == 1) {
            controller = [[QCDebugAnnoSelectController alloc] init];
        }else if (indexPath.row == 2) {
            controller = [[QCDebugCrashListController alloc] init];
        }
        
        if (controller) [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([DebugManager manager].domains.count > buttonIndex) {
        Domain *dom = [DebugManager manager].domains[buttonIndex];
        QCChangeCurrentDomain(dom);
        [NSKeyedArchiver archiveRootObject:dom toFile:SavedDomainPath()];
    }else if ([DebugManager manager].domains.count == buttonIndex) {
        UIAlertView *alert = [[UIAlertView alloc] init];
        alert.delegate = self;
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        alert.title = @"input domain";
        [alert addButtonWithTitle:@"confirm"];
        [alert addButtonWithTitle:@"cancel"];
        UITextField *textField = [alert textFieldAtIndex:0];
        textField.text = [DebugManager manager].placeholdURL?:@"";
        [alert show];
    }
    [[QCDebugLogo logo] reloadLogoText];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        Domain *dom = [Domain domain:textField.text title:nil isMain:NO];
        QCChangeCurrentDomain(dom);
        [NSKeyedArchiver archiveRootObject:dom toFile:SavedDomainPath()];
        [textField resignFirstResponder];
        [[QCDebugLogo logo] reloadLogoText];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end
