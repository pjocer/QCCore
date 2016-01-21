//
//  QCDebugLogDetailController.m
//  QCCore
//
//  Created by XuQian on 1/21/16.
//  Copyright © 2016 qcwl. All rights reserved.
//

#import "QCDebugLogDetailController.h"
#import "CrashLog.h"

@implementation QCDebugLogDetailController
{
    NSObject *_log;
    UITextView *_textView;
}

- (id)initWithLog:(id)log
{
    if (self = [super init]) {
        _log = log;
    }
    return self;
}

- (void)loadView
{
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _textView.backgroundColor = [UIColor whiteColor];
    self.view = _textView;
    
    self.title = @"日志详情";
    
    if ([_log isKindOfClass:[CrashLog class]]) {
        CrashLog *log = (CrashLog *)_log;
        NSString *str = [NSString stringWithFormat:@"APP包名：%@\nAPP版本号：%@\n沙盒：%@\n是否越狱：%@\n是否安装Cydia：%@\n设备朝向：%d\n渠道号：%@\n机型：%@\n操作系统版本号：%@\nscheme类型：%@\nAPI域名：%@\n网络类型：%@\n\n崩溃类型：%d\n信号类型：%d\n启动时间：%@\n崩溃时间：%@\n崩溃名：%@\n崩溃原因：%@\n内存操作栈：\n%@\nCPU核心数：%d\nCPU核心频率：%ld\n总线频率：%ld\n总内存：%ld\n用户内存：%ld\n剩余内存：%ld\n页面大小：%ld\n物理内存：%ld\n寄存器大小：%ld\n闪存总大小：%ld\n闪存剩余大小：%ld\n", log.name, log.appVersion, log.sandbox, log.isJB?@"是":@"否", log.isCYExist?@"是":@"否", (int)log.orientation, log.channel, log.platform, log.osv, log.scheme, log.apiDomain, log.network, log.crashType, log.signalType, log.lanchedDate, log.occursDate, log.name, log.reason, log.stack, log.cpuCount, log.cpuFrequency, log.busFrequency, log.totalMemory, log.userMemory, log.freeMemory, log.pageSize, log.physMemory, log.sockBufferSize, log.totalSDSize, log.freeSDSize];
        _textView.text = str;
    }
    
    _textView.textColor = [UIColor darkGrayColor];
    _textView.font = [UIFont systemFontOfSize:12];
    _textView.editable = NO;
}

@end
