//
//  RequestApi.h
//  QCColumbus
//
//  Created by Chen on 15/4/9.
//  Copyright (c) 2015年 Quancheng-ec. All rights reserved.
//


#ifdef DEBUG
static NSString *const DefaultAPIHost = @"http://dev.fk.com/api/"; //开发
static NSString *const TrialAPIHost = @"http://trial.fk.com/api/";
#else
static NSString* const DefaultAPIHost = @"http://api.qccost.com/"; //正式
static NSString *const TrialAPIHost = @"http://trial.qccost.com/";
#endif

//#define APIHost [[QCAccountManager defaultManager] getAccountType] == NormalAccount ? DefaultAPIHost : TrialAPIHost

//验证码等待时间
#define MAX_TIME_INTERVAL 60
//主页
static NSString *const homeIndex = @"home/index";

//个人中心
//登录
static NSString *const login = @"ucenter/login";
//密码重置
static NSString *const reset = @"ucenter/reset";
//推送token绑定
static NSString *const bindPushToken = @"ucenter/push/bind";
//推送token更新
static NSString *const updatePushToken = @"ucenter/push/update";
//推送token解绑
static NSString *const unbindPushToken = @"ucenter/push/unbind";

//获取验证码
static NSString *const getCode = @"ucenter/user/getcode";

//校验验证码
static NSString *const verifyCode = @"ucenter/user/verify";

//忘记密码重置
static NSString *const forgetVerify = @"ucenter/verify";

//版本更新检测
static NSString *const versionUpdate = @"update";

//反馈建议
static NSString *const feedback = @"ucenter/feedback";

//审批流报错
static NSString *const error = @"approve/error";

//获取管理员信息
static NSString *const roleList = @"ucenter/role/list";

//激活验证码
static NSString *const activecode = @"ucenter/activecode";

//输入密码激活账号
static NSString *const activeAccount = @"ucenter/user/active";

static NSString *const message = @"ucenter/message/setting";

static NSString *const update = @"ucenter/message/update";

static NSString *const trialCreate = @"ucenter/trial/create";

//差旅申请详情
static NSString *const tripDetail = @"trip/detail";
//生成差旅报销单
static NSString *const tripGenerate = @"trip/generate";
//报销单详情
static NSString *const expenseDetail = @"expense/detail";
//行程列表
static NSString *const tripList = @"trip/list";
//选择行程
static NSString *const scheduleAvailablelist = @"schedule/availablelist";
//费用列表
static NSString *const costList = @"cost/list";
//费用类型
static NSString *const costType = @"cost/type";

//预定
static NSString *const shops = @"restaurant/shops";
//预定首页订单
static NSString *const orderList = @"order/order/list";
//预定首页
static NSString *const dynamicHome = @"order/order/home";
//商圈
static NSString *const getRegionfields = @"restaurant/districts";
//排序
static NSString *const getSortfields = @"restaurant/sort";
//菜品
static NSString *const getCookstyle = @"restaurant/cookstyle";
//搜索建议列表
static NSString *const suggestlist = @"restaurant/suggestlist";
static NSString *const restaurantDetail = @"restaurant/detail";
//请求填写订单信息
static NSString *const preOrderInfo = @"order/preOrderInfo";

static NSString *const getCitys = @"restaurant/cities";

/********* 报表 *********/
static NSString *const costTrend = @"report/cost/trend";
static NSString *const costDistribution = @"report/cost/distribution";

