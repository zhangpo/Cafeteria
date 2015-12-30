//
//  CSDataProvider.h
//  Cafeteria
//
//  Created by chensen on 14/11/3.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFAppDotNetAPIClient.h"

@interface CSDataProvider : NSObject<NSURLConnectionDelegate>
@property(nonatomic,strong)NSDictionary *config;                //配置
@property(nonatomic,assign)id           navigationController;
@property(nonatomic,strong)NSString     *languageTag;           //选择的语言
@property(nonatomic,strong)NSString     *openTableTag;          //开台方式
@property(nonatomic,strong)NSArray      *foodsArray,*PackageItem,*foodQueryArray;//菜品及套餐
@property(nonatomic,strong)NSDictionary *VIPINFO;
@property(nonatomic,strong)NSString     *cardNum,*cardWord,*SAVETIME,*billNo,*cardID,*cardIntegral,*cardCash;
@property(nonatomic)float               remainingAmount;
+(CSDataProvider *)CSDataProviderShare;                 //初始化
+(NSArray *)getFoodClass;                               //查询菜品类别
+(NSArray *)getAllFood;                                 //查询菜品
+(NSDictionary *)loadData;                              //读取配置
+(NSArray *)selectAllFood;                              //查询全部的菜品
+(NSArray *)selectChinesePackItem:(NSString *)packID;   //查询全部的套餐明细
+(NSArray *)getAdditional:(NSString *)itcode;                              //查询全部的附加项
-(NSMutableArray *)getPackageList:(NSDictionary *)Package;//查询全部的套餐明细
- (BOOL)checkFTPSetting:(NSString *)api;                //验证ftp是否能用
//- (BOOL)updateData:(NSString *)dataname;                //更新数据
+ (void)UnzipCloseFile;                                 //解压
+(void)playSound;                                       //按键声音

#pragma mark - 好麦道
-(NSString *)HMDwebServiceIP;                              //webservice串
-(NSString *)sendFoodString:(NSString *)orderID;        //发送菜品
#pragma mark - 快餐
-(NSString *)KCCafeteriaWebServiceIP;                   //快餐WebServer地址
#pragma mark - 中餐
-(NSArray *)getCouponConsumption:(NSArray *)array;      //会员券活动
-(NSString *)ZCCafeteriaSendFoodString;                 //中餐发送菜品串
+(NSString *)ZCCafeteriaWebServiceIP;                   //中餐WebServer地址
-(NSDictionary *)ZCLogin:(NSDictionary *)info;          //中餐登录
-(NSDictionary *)ZCSend;                                //中餐发送菜品
- (NSDictionary *)ChineseFoodQueryOrder:(NSString *)mark;//中餐查询
-(NSDictionary *)ZCqueryVip;                             //中餐会员信息查询
-(NSDictionary *)ZCcardOutCouponByPre:(NSDictionary *)selectDic;//中餐券使用
-(NSDictionary *)ZCcardOutPointByPre:(NSDictionary *)selectDic; //中餐积分使用
-(NSDictionary *)ZCcancelPayment;                               //中餐取消支付
-(NSDictionary *)ZCcardOutAmt;                                  //中餐储值
-(NSDictionary *)ZCqueryDate;                                   //中餐获取消费日期
-(NSDictionary *)ZCqueryOldOrderByCrm:(NSString *)date;         //根据日期查询历史账单
-(NSDictionary *)ZCqueryOldOrder:(NSString *)date;              //查询历史账单
-(NSMutableArray *)ZCcalculationPackagePrice:(NSMutableArray *)packageItem withPackage:(NSDictionary *)package;
                                                                //中餐计算套餐的价格
+(UIImage *)imgWithContentsOfImageName:(NSString *)imgName;
+ (NSString *)md5:(NSString *)str;                      //MD5加密
+(NSString *)localizedString:(NSString *)str;
+ (NSURLSessionDataTask *)globalTimelinePosts:(NSString *)str WithBlock:(void (^)(NSDictionary *posts, NSError *error))block;


@end
