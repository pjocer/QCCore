//
//  QCDebugCrashListController.m
//  QCCore
//
//  Created by XuQian on 1/21/16.
//  Copyright © 2016 qcwl. All rights reserved.
//

#import "QCDebugCrashListController.h"
#import "CrashManager.h"
#import "QCDebugLogDetailController.h"

@interface QCDebugCrashListController () <UIAlertViewDelegate>

@end

@implementation QCDebugCrashListController

- (void)loadView
{
    [super loadView];
    
    self.title = @"崩溃日志";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(clearLogs)];
    
    
}

- (void)clearLogs
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"清空所有日志？" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"清空", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[CrashManager manager] clearHistoryLogs];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [CrashManager manager].allLogNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [CrashManager manager].allLogNames[indexPath.row][@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *crashName = [CrashManager manager].allLogNames[indexPath.row][@"name"];
    CrashLog *log = [[CrashManager manager] crashLogWithName:crashName];
    QCDebugLogDetailController *controller = [[QCDebugLogDetailController alloc] initWithLog:log];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
