//
//  QCDebugInfoController.m
//  QCCore
//
//  Created by XuQian on 1/20/16.
//  Copyright © 2016 qcwl. All rights reserved.
//

#import "QCDebugInfoController.h"
#import "QCAPIRequest.h"
#import "UIDevice+Hardware.h"
#import "NetworkUtil.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@implementation QCDebugInfoController
{
    NSMutableArray *_dataArray;
}

- (void)loadView
{
    [super loadView];
    
    self.title = @"信息采集";
    self.view.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _dataArray = [NSMutableArray array];
    
    NSMutableArray *_apiData = [NSMutableArray array];
    [_apiData addObject:@{@"title":@"APIDomain",@"detail":QCCurrentDomain().domain}];
    [_apiData addObject:@{@"title":@"APP版本",@"detail":[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]}];
    [_apiData addObject:@{@"title":@"渠道号", @"detail":@"0"}];
    
    [_dataArray addObject:_apiData];
    
    NSMutableArray *_deviceData = [NSMutableArray array];
    [_deviceData addObject:@{@"title":@"CPU频率",@"detail":[NSString stringWithFormat:@"%.2f",[[UIDevice currentDevice] cpuFrequency]/1024.0/1024.0]}];
    [_deviceData addObject:@{@"title":@"总线频率",@"detail":[NSString stringWithFormat:@"%.2fMHz",[[UIDevice currentDevice] busFrequency]/1024.0/1024.0]}];
    [_deviceData addObject:@{@"title":@"CPU核心",@"detail":[NSString stringWithFormat:@"%lu",[[UIDevice currentDevice] cpuCount]]}];
    [_deviceData addObject:@{@"title":@"总内存",@"detail":[NSString stringWithFormat:@"%.2fMB",[[UIDevice currentDevice] totalMemory]/1024.0/1024.0]}];
    [_deviceData addObject:@{@"title":@"可用内存",@"detail":[NSString stringWithFormat:@"%.2fMB",[[UIDevice currentDevice] availableMemory]/1024.0/1024.0]}];
    [_deviceData addObject:@{@"title":@"已用内存",@"detail":[NSString stringWithFormat:@"%.2fMB",[[UIDevice currentDevice] usedMemory]/1024.0/1024.0]}];
    [_deviceData addObject:@{@"title":@"页面大小",@"detail":[NSString stringWithFormat:@"%luB",[[UIDevice currentDevice] pageSize]]}];
    [_deviceData addObject:@{@"title":@"物理存储",@"detail":[NSString stringWithFormat:@"%.2fMB",[[UIDevice currentDevice] totalDiskSpace]/1024.0/1024.0]}];
    [_deviceData addObject:@{@"title":@"已用存储",@"detail":[NSString stringWithFormat:@"%.2fMB",[[UIDevice currentDevice] freeDiskSpace]/1024.0/1024.0]}];
    [_dataArray addObject:_deviceData];
    
    NSMutableArray *_netData = [NSMutableArray array];
    CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netinfo subscriberCellularProvider];
    [_netData addObject:@{@"title":@"运营商", @"detail":(carrier.carrierName?carrier.carrierName:@"未知")}];
    [_netData addObject:@{@"title":@"运营商地区号", @"detail":(carrier.mobileCountryCode?carrier.mobileCountryCode:@"未知")}];
    [_netData addObject:@{@"title":@"运营商网络编号", @"detail":(carrier.mobileNetworkCode?carrier.mobileNetworkCode:@"未知")}];
    [_netData addObject:@{@"title":@"标准国家编号", @"detail":(carrier.isoCountryCode?carrier.isoCountryCode:@"未知")}];
    [_netData addObject:@{@"title":@"voip支持", @"detail":((carrier.allowsVOIP)?@"支持":@"不支持")}];
    [_netData addObject:@{@"title":@"网络类型", @"detail":[NetSniffer defaultSniffer].currentStatusString}];
    [_netData addObject:@{@"title":@"Mac地址",@"detail":[[UIDevice currentDevice] macaddress]}];
    NSString *ipadd = IPAddress();
    [_netData addObject:@{@"title":@"IP地址",@"detail":(ipadd?ipadd:@"")}];
    [_dataArray addObject:_netData];
    
    NSMutableArray *_envData = [NSMutableArray array];
    [_envData addObject:@{@"title":@"iOS版本",@"detail":[[UIDevice currentDevice] systemVersion]}];
    [_envData addObject:@{@"title":@"电池余量",@"detail":([[UIDevice currentDevice] batteryLevel]<0)?@"未知":[NSString stringWithFormat:@"%.0f%%", [[UIDevice currentDevice] batteryLevel]*100]}];
    [_envData addObject:@{@"title":@"越狱",@"detail":[[UIDevice currentDevice] isJB]?@"已越狱":@"未越狱"}];
    [_envData addObject:@{@"title":@"Cydia",@"detail":[[UIDevice currentDevice] isCYExist]?@"已安装":@"未安装"}];
    [_dataArray addObject:_envData];
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 25;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)_dataArray[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"section";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = _dataArray[indexPath.section][indexPath.row][@"title"];
    cell.detailTextLabel.text = _dataArray[indexPath.section][indexPath.row][@"detail"];
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    return cell;
}

@end
