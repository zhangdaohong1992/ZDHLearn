//
//  APIHeader.h
//  Treasure
//
//  Created by 苹果 on 15/10/20.
//  Copyright © 2015年 YDS. All rights reserved.
//

#ifndef APIHeader_h
#define APIHeader_h

//#define BASE_URL @"http://192.168.2.15:8080/app5/"
#define PATH     @"app5/"
//#define BASE_URL @"http://fingertest.tao2.me/app/"
//#define BASE_URL @"http://test.shouzhiduobao.com:8080/app5/"

//正式服务器
#define BASE_URL @"http://finger.tao2.me/app5/"

static NSString * const getCellPhoneCheckCode = @"getCellPhoneCheckCode";/**<获取手机验证码*/
static NSString * const checkCellPhoneCheckCode = @"checkCellPhoneCheckCode";/**<验证手机验证码*/
static NSString * const login = @"login";/**<登陆*/
static NSString * const changePassword = @"changePassword";/**<修改密码*/
static NSString * const registe = @"register";/**<注册>*/

static NSString * const getUptoken = @"getUptoken";/**<获取上传凭证*/
static NSString * const updateUserInfo = @"updateUserInfo";/**<修改个人信息*/
static NSString * const getDuoBaoRecords = @"getDuoBaoRecords";/**<获取个人淘宝记录*/
static NSString * const getLuckyRecords = @"getLuckyRecords";/**<获取个人中奖记录*/
static NSString * const getUserInfo = @"getUserInfo";/**<获取个人信息*/
static NSString * const getIncomeBills = @"getIncomeBills";/**<获取个人流水账*/

static NSString * const getSlideShowAndNotice = @"getSlideShowAndNotice";/**<获取轮播图和通知*/
static NSString * const getItemsByCatagoryAndSort = @"getItemsByCategoryAndSort";/**<商品列表*/
static NSString * const getCategories = @"getCategories";/**<获取分类列表*/
static NSString * const getItemInfo = @"getItemInfo";/**<获取商品详情*/
static NSString * const queryItem = @"queryItem";/**<搜索商品*/
static NSString * const getHotWords = @"getHotWords";/**<获取热门词汇*/
static NSString * const getJoinRecoeds = @"getJoinRecoeds";/**<获取参与记录*/
static NSString * const getPastTerms = @"getPastTerms";/**<往期揭晓*/
static NSString * const getShowOrders = @"getShowOrders";/**<获取晒单列表*/
static NSString * const getshowOrderDetail = @"getshowOrderDetail";/**<晒单详情*/
static NSString * const getNewTerms = @"getNewTerms";/**<最新揭晓列表*/
static NSString * const confirmOrder = @"confirmOrder";/**<确认收货*/
static NSString * const showOrder = @"showOrder";/**<晒单*/
static NSString * const getMyShowOrders = @"getMyShowOrders";/**<我的订单记录*/
static NSString * const getOrderInfo = @"getOrderInfo";/**<获取中奖商品详情*/

static NSString * const queryMoney = @"queryMoney";/**<获取金额*/
static NSString * const submintOrderInfo = @"submintOrderInfo";/**<提交订单信息*/
static NSString * const payItemTerms = @"payItemTerms";/**<购买商品期数*/
static NSString * const getItemDescribution = @"getItemDescribution";/**<获取图文详情*/
static NSString * const alipay = @"alipay";/**<充值*/
static NSString * const flushCart = @"flushCart";/**<刷新购物车*/

static NSString * const queryServiceInfo = @"queryServiceInfo";/**<获取客服信息接口*/
static NSString * const question = @"question";/**<常见问题*/
static NSString * const feedback = @"feedback";/**<反馈*/
static NSString * const userGuide = @"userGuide";/**<用户指南*/
static NSString * const serviceAgreement = @"serviceAgreement";/**<服务协议*/
static NSString * const aboutUs = @"aboutUs";/**<关于我们*/
static NSString * const queryCalculating = @"queryCalculating";/**<查看计算详情*/

static NSString * const recharge = @"recharge";/**<充值审核时调用*/
static NSString * const aliReq = @"aliReq";/**<支付审核时调用*/
static NSString * const loginInvite = @"loginInvite";/**<发展代理*/

#endif /* APIHeader_h */
