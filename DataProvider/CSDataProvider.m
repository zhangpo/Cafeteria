
//
//  CSDataProvider.m
//  Cafeteria
//
//  Created by chensen on 14/11/3.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import "CSDataProvider.h"
#import <sqlite3.h>
#import <CommonCrypto/CommonDigest.h>
#import "ZipArchive.h"
#import "SBJSON.h"
#import "NSObject+SBJSON.h"
#import "BSWebServiceAgent.h"
#import "XMLDictionary.h"
#import "SQLFile.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVFoundation.h>



@implementation CSDataProvider
{
    
}
@synthesize config=_config,navigationController=_navigationController,foodsArray=_foodsArray,PackageItem=_PackageItem,languageTag=_languageTag,openTableTag=_openTableTag,cardNum=_cardNum,cardID=_cardID,foodQueryArray=_foodQueryArray,VIPINFO=_VIPINFO,cardWord=_cardWord,SAVETIME=_SAVETIME,remainingAmount=_remainingAmount,billNo=_billNo,cardCash=_cardCash,cardIntegral=_cardIntegral;
static CSDataProvider *_CSDataProvider;
NSDictionary *settingDict=nil;
/**
 *  实例化
 *
 *  @return
 */
+(CSDataProvider *)CSDataProviderShare
{
    if (!_CSDataProvider) {
        _CSDataProvider=[[CSDataProvider alloc] init];
        
    }
    return _CSDataProvider;
}

#pragma mark - 读取语言包
+(NSString *)localizedString:(NSString *)str{
    /**
     *  判断配置设置语言
     */
    NSDictionary *dict=[[NSDictionary alloc] init];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CSLanguage.plist" ofType:nil];
    settingDict = [NSDictionary dictionaryWithContentsOfFile:path];
    if ([languageMode isEqualToString:@"cn"]) {
        dict=[settingDict objectForKey:@"Chinese"];
    }else if ([languageMode isEqualToString:@"en"]){
        dict=[settingDict objectForKey:@"English"];
    }else if ([languageMode isEqualToString:@"tw"]){
        dict=[settingDict objectForKey:@"Trandtion"];
    }
    /**
     *  判断程序里选择语言
     */
    if ([[CSDataProvider CSDataProviderShare].languageTag isEqualToString:@"1"]) {
        dict=[settingDict objectForKey:@"Chinese"];
    }else if ([[CSDataProvider CSDataProviderShare].languageTag isEqualToString:@"2"]){
        dict=[settingDict objectForKey:@"English"];
    }else if ([[CSDataProvider CSDataProviderShare].languageTag isEqualToString:@"11"]){
        dict=[settingDict objectForKey:@"Japanese"];
    }
    NSString *strstr = [dict objectForKey:str];
    if (!strstr)
        strstr = str;
	return strstr;
}

/**
 
 *  读取配置文件
 *
 *  @return
 */
+(NSDictionary *)loadData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PageConfig.plist" ofType:nil];
    NSMutableDictionary *pageConfig = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"HMDPageConfig.plist" ofType:nil];
//    NSMutableDictionary *pageConfig = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
    return pageConfig;
}
/**
 *  查询菜品类别
 *
 *  @return
 */
+(NSArray *)getFoodClass
{
    if([Mode isEqualToString:@"zc"])
    {
        NSMutableArray *array=[CSDataProvider getDataFromSQLByCommand:ZC_SELECT_CLASS];
        NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:@"88",@"GRP",@"套餐",@"DES",@"TC.png",@"image", nil];
        //    array addObject:
        [array insertObject:dict atIndex:0];
        return array;
    }else
    {
        NSMutableArray *array=[CSDataProvider getDataFromSQLByCommand:KC_SELECT_CLASS];
        //    array addObject:
        return array;
    }
}
/**
 *  查询全部的菜品
 *
 *  @return
 */
+(NSArray *)selectAllFood
{
    /**
     *  查询类别
     */
    NSArray *array=[CSDataProvider getFoodClass];
    NSMutableArray *orders=[[NSMutableArray alloc] init];
    NSArray *unitArray=[CSDataProvider getDataFromSQLByCommand:KC_SELECT_UNIT];
    for (NSDictionary *dict in array) {
        /**
         *  根据类别查找菜品
         */
        if ([[dict objectForKey:@"GRP"] intValue]==88&&[Mode isEqualToString:@"zc"]
            ) {
            NSArray *order=[CSDataProvider getDataFromSQLByCommand:ZC_SELECT_PACKAGE];
            for (NSDictionary *dict in order) {
                [dict setValue:@"88" forKey:@"CLASS"];
                [dict setValue:@"1" forKey:@"ISTC"];
            }
            [orders addObject:order];
        }else
        {
            NSArray *order;
            NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"switch"]);
            if (![Mode isEqualToString:@"zc"]) {
                if ([[CSDataProvider CSDataProviderShare].openTableTag intValue]==4) {
                    order=[CSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:SELECT_TOGO_FOOD_FOR_CLASS,[dict objectForKey:@"GRP"]]];
                    
                }else
                {
                    order=[CSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:SELECT_ALLFOOD_FOR_CLASS,[dict objectForKey:@"GRP"]]];
                }
                for (NSDictionary *dict in order) {
                    for (int i=0; i<6; i++) {
                        if ([[dict objectForKey:[NSString stringWithFormat:@"UNIT%d",i+1]] length]>0&&![[dict objectForKey:[NSString stringWithFormat:@"UNIT%d",i+1]] isEqualToString:[NSString stringWithFormat:@"~_UNIT%d_~",i+1]]) {
                            for (NSDictionary *unit in unitArray) {
                                if ([[dict objectForKey:[NSString stringWithFormat:@"UNIT%d",i+1]] isEqualToString:[unit objectForKey:@"code"]]) {
                                    [dict setValue:[unit objectForKey:@"name"] forKey:[NSString stringWithFormat:@"UNITS%d",i+1]];
                                    if (i>=1) {
                                        //多规格加标识
                                        [dict setValue:@"1" forKey:@"ISUNITS"];
                                    }
                                    break;
                                }
                            }
                            
                        }
                    }
                }
                if ([CSDataProvider CSDataProviderShare].languageTag) {
                    for (NSDictionary *dict in order) {
                        NSArray *array=[CSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:SELECT_LANGUAG,[dict objectForKey:@"ITCODE"],[CSDataProvider CSDataProviderShare].languageTag]];
                        if ([array count]>0) {
                            [dict setValue:[[array lastObject] objectForKey:@"PNAME"] forKey:@"DES"];
                        }
                        
                    }
                }
                
                [orders addObject:order];
            }else
            {
                order=[CSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:SELECT_ALLFOOD_FOR_CLASS,[dict objectForKey:@"GRP"]]];
                for (NSDictionary *orderDic in order) {
                    for (int i=1;i<5;i++){
                        NSString *unit = [orderDic objectForKey:[NSString stringWithFormat:@"UNIT%d",i+1]];
                        if (unit.length>1) {
                            [orderDic setValue:@"1" forKey:@"ISUNITS"];
                        }
                    }
                }
                [orders addObject:order];
            }
            
        }
    }
    return [NSArray arrayWithArray:orders];
}
/**
 *  查询套餐明细
 *
 *  @param packID套餐编码
 *
 *  @return
 */
+(NSArray *)selectChinesePackItem:(NSString *)packID
{
    /**
     *  套餐里的所有的主菜
     */
    NSArray *array=[CSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:SELECT_PACKDTL,packID]];
    NSMutableArray *comboArray=[[NSMutableArray alloc] init];
    NSMutableArray *selectPackage=[[NSMutableArray alloc] init];
    int i=0;
    for (NSDictionary *dict in array) {
        
        NSMutableArray *ary=[[NSMutableArray alloc] init];
        [dict setValue:[NSString stringWithFormat:@"%d",i] forKey:@"PRODUCTTC_ORDER"];
        [ary addObject:dict];
        if ([[dict objectForKey:@"TAG"]isEqualToString:@"Y"]) {
            /**
             *  套餐可换购
             */
            NSArray *itemArray=[CSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:SELECT_ITEMPKG,packID,[dict objectForKey:@"ITEM"]]];
            for (NSDictionary *dic in itemArray) {
                [dic setValue:[NSString stringWithFormat:@"%d",i] forKey:@"PRODUCTTC_ORDER"];
            }
            [ary addObjectsFromArray:itemArray];
        }else
        {
            [dict setValue:@"1" forKey:@"total"];
            [selectPackage addObject:dict];
            
        }
        [comboArray addObject:ary];
        i++;
    }
    [CSDataProvider CSDataProviderShare].PackageItem=selectPackage;
    return comboArray;
}
#pragma mark - 套餐
-(NSMutableArray *)getPackageList:(NSDictionary *)Package
{
    /**
     *  根据套餐编码查询组
     */
    NSString *PackageId=[Package objectForKey:@"ITCODE"];
    NSArray *groupArray=[CSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:SELECT_PACKAGE_GROUP,PackageId]];
//    NSDictionary *packageDic=[[CSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:@"select * from food where ITCODE='%@'",PackageId]] lastObject];
    
    NSMutableArray *returnGroupArray=[NSMutableArray array];
    for (NSDictionary *groupDic in groupArray) {
        /**
         *  套餐明细
         */
        NSMutableArray *productArray=[[NSMutableArray alloc] init];
        if ([[Package objectForKey:@"TCMONEYMODE"] intValue]==2) {
            NSLog(@"%@",[NSString stringWithFormat:SELECT_PRODUCTS_SUB_2,PackageId,[groupDic objectForKey:@"PRODUCTTC_ORDER"]]);
            [productArray addObjectsFromArray:[CSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:SELECT_PRODUCTS_SUB_2,PackageId,[groupDic objectForKey:@"PRODUCTTC_ORDER"]]]];
        }else
        {
            NSLog(@"%@",[NSString stringWithFormat:SELECT_PRODUCTS_SUB,PackageId,[groupDic objectForKey:@"PRODUCTTC_ORDER"]]);
            [productArray addObjectsFromArray:[CSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:SELECT_PRODUCTS_SUB,PackageId,[groupDic objectForKey:@"PRODUCTTC_ORDER"]]]];
        }
        
        /**
         *  将改组的最大最小数量放入数据中
         */
        for (NSDictionary *dict in productArray) {
            [dict setValue:[groupDic objectForKey:@"MAXCNT"] forKey:@"TYPMAXCNT"];
            [dict setValue:[groupDic objectForKey:@"MINCNT"] forKey:@"TYPMINCNT"];
            [dict setValue:[Package objectForKey:@"TCMONEYMODE"] forKey:@"TCMONEYMODE"];
            if ([[dict objectForKey:@"MINCNT"] intValue]>0) {
                if ([productArray count]==1||([productArray count]>1&&[[dict objectForKey:@"defualtS"] intValue]!=0)) {
                    [dict setValue:[NSNumber numberWithFloat:[[dict objectForKey:@"MINCNT"] floatValue]*[[dict objectForKey:@"CNT"] floatValue]] forKey:@"total"];
                    NSMutableArray *selectPackage=[CSDataProvider CSDataProviderShare].PackageItem;
                    if (!selectPackage) {
                        selectPackage=[[NSMutableArray alloc] init];
                    }
                    [selectPackage addObject:dict];
                    [CSDataProvider CSDataProviderShare].PackageItem=selectPackage;
                }
            }
            
        }
        /**
         *  删除 defualtS=0的数据
         */
        if ([productArray count]>1) {
            [productArray removeObjectAtIndex:0];
        }
        /**
         *  将菜品放在分组的数组中
         */
        [returnGroupArray addObject:productArray];
    }
    return returnGroupArray;
}

/**
 *  查询菜品
 *
 *  @return
 */
+(NSArray *)getAllFood
{
    if ([Mode isEqualToString:@"zc"]) {
        NSArray *array=[CSDataProvider getDataFromSQLByCommand:SELECT_ALLFOOD];
        return array;
    }else
    {
        NSArray *array;
        
        if ([[CSDataProvider CSDataProviderShare].openTableTag intValue]==4) {
            array=[CSDataProvider getDataFromSQLByCommand:SELECT_TOGOFOOD];
        }else
        {
            array=[CSDataProvider getDataFromSQLByCommand:SELECT_ALLFOOD];
        }
        if ([CSDataProvider CSDataProviderShare].languageTag) {
            for (NSDictionary *dict in array) {
                NSArray *array=[CSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:SELECT_LANGUAG,[dict objectForKey:@"ITCODE"],[CSDataProvider CSDataProviderShare].languageTag]];
                [dict setValue:[[array lastObject] objectForKey:@"PNAME"] forKey:@"DES"];
            }
        }
        return array;
    }
    
}
/**
 *  判断会员券是否存在活动
 *
 *  @param array 会员券和积分
 *
 *  @return
 */


-(NSArray *)getCouponConsumption:(NSArray *)array
{
    NSMutableArray *returnArray=[[NSMutableArray alloc] init];
    NSMutableArray *couponConsumptionArray=[[NSMutableArray alloc] init];
    for (NSDictionary *dict in array) {
        NSArray *CouponConsumption=[CSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:SELECT_PREFERENTIAL,[dict objectForKey:@"tickettypno"]]];
        if ([CouponConsumption count]>0) {
            [dict setValue:[[CouponConsumption lastObject] objectForKey:@"PK_ACTM"] forKey:@"PK_ACTM"];
            [couponConsumptionArray addObject:dict];
        }
    }
    NSArray *Integralactivities=[CSDataProvider getDataFromSQLByCommand:SELECT_INTEGRAL];
    return [NSArray arrayWithObjects:Integralactivities,couponConsumptionArray, nil];
}

/**
 *  查询附加项
 *
 *  @return
 */
+(NSArray *)getAdditional:(NSString *)itcode
{
    if ([Mode isEqualToString:@"zc"]) {
        NSArray *array=[CSDataProvider getDataFromSQLByCommand:SELECT_ADDTITION];
        return array;
    }else
    {
        NSArray *array=[[NSArray array] init];
        array=[CSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:SELECT_ADDTITION_FOR_PCODE,itcode]];
        if ([array count]==0) {
            array=[CSDataProvider getDataFromSQLByCommand:SELECT_KC_ADDTITION];
        }
        
        return array;
    }
    
}
/**
 *  数据库路径
 *
 *  @return
 */
+(NSString *)sqlitePath
{
    NSString *path =[@"BookSystem.sqlite" documentPath];
    return path;
}
/**
 *  数据库查询
 *
 *  @param cmd sql语句
 *
 *  @return
 */
+ (id)getDataFromSQLByCommand:(NSString *)cmd{
    NSMutableArray *ary = [NSMutableArray array];
    NSString *path = [self sqlitePath];
    sqlite3 *db;
    sqlite3_stmt *stat;
    NSString *sqlcmd = cmd;
    
    if (sqlite3_open([path UTF8String], &db)==SQLITE_OK){
        if (sqlite3_prepare_v2(db, [sqlcmd UTF8String], -1, &stat, nil)==SQLITE_OK){
            while (sqlite3_step(stat)==SQLITE_ROW) {
                int count = sqlite3_column_count(stat);
                NSMutableDictionary *mutDC = [NSMutableDictionary dictionary];
                for (int i=0;i<count;i++){
                    char *foodKey = (char *)sqlite3_column_name(stat, i);
                    char *foodValue = (char *)sqlite3_column_text(stat, i);
                    NSString *strKey = nil,*strValue = nil;
                    
                    if (foodKey)
                        strKey = [NSString stringWithUTF8String:foodKey];
                    if (foodValue)
                        strValue = [NSString stringWithUTF8String:foodValue];
                    if (strKey && strValue)
                        [mutDC setObject:strValue forKey:strKey];
                }
                [ary addObject:mutDC];
            }
        }
        sqlite3_finalize(stat);
    }
    sqlite3_close(db);
    
    return ary;
}
#pragma mark ftp相关设置
/**
 *  验证ftp是否能用
 *
 *  @param api ftp地址
 *
 *  @return
 */
- (BOOL)checkFTPSetting:(NSString *)api
{
    
    BOOL valid = NO;;
    NSString *str = [api stringByReplacingOccurrencesOfString:@"/" withString:@""];
    NSUserDefaults *userDef=[NSUserDefaults standardUserDefaults];
    if ([[userDef objectForKey:@"user"] length]==0 || [[userDef objectForKey:@"password"] length]==0){
        if ([str length]==0)
            str = @"null";
        else
            str = [NSString stringWithFormat:@"ftp://%@/BookSystem/booksystem.sqlite",str];
    }
    else{
        if ([str length]==0)
            str = @"null";
        else
            str = [NSString stringWithFormat:@"ftp://%@:%@@%@/BookSystem/booksystem.sqlite",[userDef objectForKey:@"user"],[userDef objectForKey:@"password"],str];
    }
    NSURLRequest *request;
    NSURL *url = [NSURL URLWithString:str];
    request = [[NSURLRequest alloc] initWithURL:url
                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                timeoutInterval:5.0];
    // retreive the data using timeout
    NSURLResponse* response;
    NSError *error;
    error = nil;
    response = nil;
    NSData *serviceData = [NSURLConnection sendSynchronousRequest:request
                                                returningResponse:&response
                                                            error:&error];
    NSLog(@"Error Info:%@",error);
    if (!serviceData) {
        valid = NO;
    }
    else{
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        NSLog(@"%@",data);
        if (data==nil){
            valid = NO;
            
        }
        
        else{
            valid = YES;
            [[NSUserDefaults standardUserDefaults] setObject:api forKey:@"api"];
        }
    }
    return valid;
}
#pragma mark - 解压文件
+ (void)UnzipCloseFile
{
    NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *localFilePath = [documentsDirectoryPath stringByAppendingPathComponent:@"booksystem.zip"];
    
    ZipArchive *archive = [[ZipArchive alloc] init];
    //1
    if ([archive UnzipOpenFile:localFilePath])
    {
        // 2
        BOOL ret = [archive UnzipFileTo:documentsDirectoryPath overWrite: YES];
        if (NO == ret)
        {
            NSLog(@"fail");
        }
        [archive UnzipCloseFile];
    }
}
#pragma mark - 发送菜品的串
-(NSString *)sendFoodString:(NSString *)orderID
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%.f",a];
    NSMutableString *mutfood = [NSMutableString string];
    for (int i=0; i<[CSDataProvider CSDataProviderShare].foodsArray.count; i++) {
        NSDictionary *dict=[[CSDataProvider CSDataProviderShare].foodsArray objectAtIndex:i];
        //套餐
        if ([[dict objectForKey:@"ISTC"] isEqualToString:@"1"]) {
            NSString *PKID=[NSString stringWithFormat:@"%@%@%@%d",orderID,[CSDataProvider CSDataProviderShare].openTableTag,timeString,i];
            [mutfood appendFormat:@"%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@",PKID,[dict objectForKey:@"ITCODE"],@"",[dict objectForKey:@"ITCODE"],@"",@"",[dict objectForKey:@"total"],@"0",@"",@"",[dict objectForKey:@"PRICE"],@"",@"0",@"1",[dict objectForKey:@"UNIT"],[dict objectForKey:@"ISTC"],@""];
            [mutfood appendString:@";"];
            for (NSDictionary *combo in [dict objectForKey:@"combo"]) {
                NSArray *array=[combo objectForKey:@"addition"];
                NSMutableString *Fujiacode=[[NSMutableString alloc] init];
                NSMutableString *FujiaName=[[NSMutableString alloc] init];
                NSMutableString *FujiaPrice=[[NSMutableString alloc] init];
                [Fujiacode appendString:@""];
                [FujiaName appendString:@""];
                [FujiaPrice appendString:@""];
                for (NSDictionary *dict1 in array) {
                    [Fujiacode appendFormat:@"%@",[dict1 objectForKey:@"FCODE"]];
                    [Fujiacode appendString:@"!"];
                    [FujiaName appendFormat:@"%@",[dict1 objectForKey:@"FNAME"]];
                    [FujiaName appendString:@"!"];
                    [FujiaPrice appendFormat:@"%@",[dict1 objectForKey:@"FPRICE"]];
                    [FujiaPrice appendString:@"!"];
                }
                [mutfood appendFormat:@"%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@",PKID,[combo objectForKey:@"PCODE1"],@"",[combo objectForKey:@"PCODE"],@"",@"",[dict objectForKey:@"total"],@"0",Fujiacode,FujiaName,[combo objectForKey:@"PRICE"],FujiaPrice,@"0",@"1",[combo objectForKey:@"UNIT"],@"1",@""];
                [mutfood appendString:@";"];
            }
        }
        else
        {
            NSString *PKID=[NSString stringWithFormat:@"%@%@%@%d",orderID,[CSDataProvider CSDataProviderShare].openTableTag,timeString,i];
            NSArray *array=[dict objectForKey:@"addition"];
            NSMutableString *Fujiacode=[[NSMutableString alloc] init];
            NSMutableString *FujiaName=[[NSMutableString alloc] init];
            NSMutableString *FujiaPrice=[[NSMutableString alloc] init];
            [Fujiacode appendString:@""];
            [FujiaName appendString:@""];
            [FujiaPrice appendString:@""];
            for (NSDictionary *dict1 in array) {
                [Fujiacode appendFormat:@"%@",[dict1 objectForKey:@"FCODE"]];
                [Fujiacode appendString:@"!"];
                [FujiaName appendFormat:@"%@",[dict1 objectForKey:@"FNAME"]];
                [FujiaName appendString:@"!"];
                [FujiaPrice appendFormat:@"%@",[dict1 objectForKey:@"FPRICE"]];
                [FujiaPrice appendString:@"!"];
            }
            [mutfood appendFormat:@"%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@",PKID,[dict objectForKey:@"ITCODE"],@"",@"",@"",@"",[dict objectForKey:@"total"],@"0",Fujiacode,FujiaName,[dict objectForKey:@"PRICE"],FujiaPrice,@"0",@"1",[dict objectForKey:@"UNIT"],[dict objectForKey:@"ISTC"],@""];
            [mutfood appendString:@";"];
        }
        
    }
    NSString *pdaid = [NSString stringWithFormat:@"%@@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"iPadID"],[[NSUserDefaults standardUserDefaults] objectForKey:@"POSID"]];
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&chkCode=%@&tableNum=%@&orderId=%@&productList=%@&rebackReason=&immediateOrWait=%@",pdaid,@"",@"",orderID,orderID,mutfood,@"1"];
    return strParam;
}

#pragma mark - 中餐发送菜品字符串
-(NSString *)ZCCafeteriaSendFoodString
{
    NSMutableArray *foodsAry=[[NSMutableArray alloc] init];//菜品数组
    for (int i=0; i<[_foodsArray count]; i++) {
        NSDictionary *food=[_foodsArray objectAtIndex:i];
        //判断是否套餐
        if ([food objectForKey:@"PACKID"]) {
            for (int j=0; j<[[food objectForKey:@"combo"] count]; j++)
            {
                NSMutableDictionary *comboDic=[[NSMutableDictionary alloc] init];
                NSDictionary *combo=[[food objectForKey:@"combo"] objectAtIndex:j];
                //套餐编码
                [comboDic setObject:[combo objectForKey:@"PACKID"] forKey:@"tcno"];
                //套餐数量
                [comboDic setObject:@"1" forKey:@"tccnt"];
                //菜品编码
                [comboDic setObject:[combo objectForKey:@"ITEM"] forKey:@"foodcode"];
                //套餐编码
                NSLog(@"%@",[combo objectForKey:@"ITEM"]);
                [comboDic setObject:[combo objectForKey:@"PACKID"] forKey:@"tcItem"];
                //菜品数量
                [comboDic setObject:[NSNumber numberWithFloat:[[combo objectForKey:@"CNT"] floatValue]*[[combo objectForKey:@"total"] floatValue]] forKey:@"foodcnt"];
                //套餐优惠
                [comboDic setObject:[NSNumber numberWithFloat:[[combo objectForKey:@"tcDisc"] floatValue]] forKey:@"tcDisc"];
                //套餐价格
                [comboDic setObject:[combo objectForKey:@"PRICE"] forKey:@"tcAmt"];
                //菜品价格
                [comboDic setObject:[food objectForKey:@"PRICE"] forKey:@"foodprice"];
                //菜品单位
                [comboDic setObject:[combo objectForKey:@"UNIT"] forKey:@"foodunit"];
                
                //第二单位数量
                [comboDic setObject:@"" forKey:@"foodcnt2"];
                //套餐中菜品的序号
                [comboDic setObject:[NSNumber numberWithInt:j+1] forKey:@"tcfoodno"];
                //套餐的唯一标志
                [comboDic setObject:[NSNumber numberWithInt:i] forKey:@"tc"];
                //判断是否有附加项
                if ([combo objectForKey:@"addition"]) {
                    int k=0;
                    for (NSDictionary *additional in [combo objectForKey:@"addition"]) {
                        //附加项编码
                        [comboDic setObject:[additional objectForKey:@"DES"] forKey:[NSString stringWithFormat:@"item%d",k+1]];
                        [comboDic setObject:[additional objectForKey:@"PRICE1"] forKey:[NSString stringWithFormat:@"price%d",k+1]];
                        k++;
                        if (k==5) {
                            break;
                        }
                    }
                }
                [foodsAry addObject:comboDic];
            }
        }else
        {
            NSMutableDictionary *foodDic=[[NSMutableDictionary alloc] init];
            //套餐编码
            [foodDic setObject:@"-1" forKey:@"tcno"];
            //套餐数量
            [foodDic setObject:@"0" forKey:@"tccnt"];
            //菜品编码
            [foodDic setObject:[food objectForKey:@"ITCODE"] forKey:@"foodcode"];
            //菜品数量
            [foodDic setObject:[NSNumber numberWithFloat:[[food objectForKey:@"total"] floatValue]] forKey:@"foodcnt"];
            //菜品单位
            [foodDic setObject:[food objectForKey:@"UNIT"] forKey:@"foodunit"];
            //菜品价格
            [foodDic setObject:[food objectForKey:@"PRICE"] forKey:@"foodprice"];
            //菜品第二单位
            [foodDic setObject:@"" forKey:@"foodcnt2"];
            //套餐中菜品的序号
            [foodDic setObject:[NSNumber numberWithInt:0] forKey:@"tcfoodno"];
            //套餐的唯一标志
//            [foodDic setObject:[NSNumber numberWithInt:i] forKey:@"tc"];
            if ([food objectForKey:@"addition"]) {
                int k=0;
                for (NSDictionary *additional in [food objectForKey:@"addition"]) {
                    //附加项编码
                    [foodDic setObject:[additional objectForKey:@"DES"] forKey:[NSString stringWithFormat:@"item%d",k+1]];
                    [foodDic setObject:[additional objectForKey:@"PRICE1"] forKey:[NSString stringWithFormat:@"price%d",k+1]];
                    k++;
                    if (k==5) {
                        break;
                    }
                }
            }
            [foodsAry addObject:foodDic];
        }
    }
    //加菜品加到
    NSMutableDictionary *rootDic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:foodsAry,@"foodList",[[NSUserDefaults standardUserDefaults] objectForKey:@"iPadID"],@"padid",[[NSUserDefaults standardUserDefaults] objectForKey:@"POSID"],@"tableinit",_cardID,@"cardid", nil];

    //json转换
    return [NSString stringWithFormat:@"%@",[rootDic JSONRepresentation]];
}


#pragma mark - 中餐请求
#pragma mark 登录
-(NSDictionary *)ZCLogin:(NSDictionary *)info
{
    //获取当前时间
    NSDate *datenow = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    //用[NSDate date]可以获取系统当前时间
    NSString *date = [dateFormatter stringFromDate:datenow];
    NSString *pwd=[CSDataProvider md5:[NSString stringWithFormat:@"%@-%@",date,[info objectForKey:@"password"]]];
    NSString *dataInfo=[NSString stringWithFormat:@"padid=%@&cardno=%@&pwd=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"iPadID"],[info objectForKey:@"user"],pwd];
    NSDictionary *dict=[self PostDataApi:@"login" Data:dataInfo];
    return dict;
}
#pragma mark 发送
-(NSDictionary *)ZCSend
{
    NSDictionary *dict=[self PostDataApi:@"orderFood" Data:[NSString stringWithFormat:@"data=%@",[self ZCCafeteriaSendFoodString]]];
    return dict;
}
#pragma mark 中餐查询账单接口
- (NSDictionary *)ChineseFoodQueryOrder:(NSString *)mark
{
    NSString *url=[NSString stringWithFormat:@"padid=%@&tableinit=%@&mark=%@&cardid=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"iPadID"],[[NSUserDefaults standardUserDefaults] objectForKey:@"POSID"],mark,_cardID];
    NSDictionary *dict=[self PostDataApi:@"queryOrder" Data:url];
    NSMutableArray *showArray=[[NSMutableArray alloc] init];
    if ([[dict objectForKey:@"state"]intValue]==1&&[[[dict objectForKey:@"msg"] objectForKey:@"foodList"] count]>0) {
        
        NSMutableArray *foodAry=[[dict objectForKey:@"msg"] objectForKey:@"foodList"];
        [CSDataProvider CSDataProviderShare].billNo=[[foodAry lastObject] objectForKey:@"CODE"];
        for (NSDictionary *food in foodAry) {
            if ([[food objectForKey:@"PACKID"] intValue]>0&&[[food objectForKey:@"PACKINDEX"] intValue]==1) {
                NSMutableArray *packAry=[[NSMutableArray alloc] init];
                NSMutableDictionary *packDic=[[NSMutableDictionary alloc] init];
                [packDic setObject:[food objectForKey:@"PACKAGEDES"] forKey:@"ITEMDES"];
                [packDic setObject:[food objectForKey:@"PACKPRICE"] forKey:@"AMT"];
                [packDic setObject:@"PACKAGE" forKey:@"TAG"];
                [packDic setObject:@"1" forKey:@"CNT"];
                for (NSDictionary *foodDic in foodAry) {
                    if ([[foodDic objectForKey:@"PACKID"] isEqualToString:[food objectForKey:@"PACKID"]]&&[[foodDic objectForKey:@"PKGTAG"] isEqualToString:[food objectForKey:@"PKGTAG"]]) {
                        //                        [foodDic setObject:@"PACKITEM" forKey:@"TAG"];
                        [foodDic setValue:@"PACKITEM" forKey:@"TAG"];
                        [packAry addObject:foodDic];
                    }
                }
                [packDic setObject:packAry forKey:@"combo"];
                [showArray addObject:packDic];
                
            }
            if ([[food objectForKey:@"PACKID"] intValue]==0) {
                [showArray addObject:food];
            }
        }
        
    }
    else
    {
        return dict;
    }
    NSArray *payment=[[NSArray alloc] init];
    
    if ([dict objectForKey:@"msg"]) {
        
        payment=[[dict objectForKey:@"msg"] objectForKey:@"payment"];
    }
    
    return [NSDictionary dictionaryWithObjectsAndKeys:[dict objectForKey:@"state"],@"state",showArray,@"foodList",payment,@"payment", nil];
}
#pragma mark - 会员信息查询
-(NSDictionary *)ZCqueryVip
{
    NSString *url=[NSString stringWithFormat:@"padid=%@&cardno=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"iPadID"],[CSDataProvider CSDataProviderShare].cardNum];
    NSDictionary *dict=[self PostDataApi:@"queryVip" Data:url];
    return dict;
}
#pragma mark - 中餐券使用
-(NSDictionary *)ZCcardOutCouponByPre:(NSDictionary *)selectDic
{
    /* @Description:扣电子券
	 * @Title:cardOutCoupon
	 * @Author:Mc
	 * @param padid pad编码
	 * @param pactcode 活动编码
	 * @param amt 支付金额
	 * @param flag 是否结束账单
	 * @param nbzero 抹零
	 * @param cardNo 卡号
	 * @param couponCode 券编码
	 * @param couponAmt 券金额 200=50
	 * @param password 密码
	 * @param billno 账单号*/
    NSString *pwd=[CSDataProvider CSDataProviderShare].cardWord;
    float amt=[[selectDic objectForKey:@"ticketmoney"] floatValue]>=[CSDataProvider CSDataProviderShare].remainingAmount?[CSDataProvider CSDataProviderShare].remainingAmount:[[selectDic objectForKey:@"ticketmoney"] floatValue];
    
    float couponAmt=[[selectDic objectForKey:@"ticketamt"] floatValue]==0?[[selectDic objectForKey:@"ticketmoney"] floatValue]*(1-[[selectDic objectForKey:@"ticketrate"] floatValue]/100):[[selectDic objectForKey:@"ticketmoney"] floatValue]-[[selectDic objectForKey:@"ticketamt"] floatValue];
    NSString *flag=[[selectDic objectForKey:@"ticketmoney"] floatValue]>=[CSDataProvider CSDataProviderShare].remainingAmount?@"Y":@"N";
    NSString *weatherUrl1=[NSString stringWithFormat:@"padid=%@&pactcode=%@&amt=%.2f&flag=%@&nbzero=%@&cardno=%@&couponCode=%@&couponAmt=%.2f&password=%@&billno=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"iPadID"],[selectDic objectForKey:@"PK_ACTM"],amt,flag,@"0",[CSDataProvider CSDataProviderShare].cardNum,[selectDic objectForKey:@"ticketno"],couponAmt,pwd,[CSDataProvider CSDataProviderShare].billNo];
    return [self PostDataApi:@"cardOutCouponByPre" Data:weatherUrl1];
}
#pragma mark - 中餐积分使用
-(NSDictionary *)ZCcardOutPointByPre:(NSDictionary *)selectDic
{
    /**
	 * @param padid pad id
	 * @param billno 账单号
	 * @param amt 支付金额  NDERATENUM
	 * @param flag 是否结束支付
	 * @param nbzero 抹零   0
	 * @param cardNo 卡号
	 * @param fen 扣积分数  IFENDISCNUM
	 * @param password
	 * @param pactcode 活动编码 VCODE
	 */
    
    NSString *pwd=[CSDataProvider CSDataProviderShare].cardWord;
    float amt=[[selectDic objectForKey:@"NDERATENUM"] floatValue]>=[CSDataProvider CSDataProviderShare].remainingAmount?[CSDataProvider CSDataProviderShare].remainingAmount:[[selectDic objectForKey:@"NDERATENUM"] floatValue];
    
    NSString *flag=[[selectDic objectForKey:@"NDERATENUM"] floatValue]>=[CSDataProvider CSDataProviderShare].remainingAmount?@"Y":@"N";
    NSString *weatherUrl1=[NSString stringWithFormat:@"padid=%@&billno=%@&amt=%.2f&flag=%@&nbzero=%@&cardno=%@&fen=%@&password=%@&pactcode=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"iPadID"],[CSDataProvider CSDataProviderShare].billNo,amt,flag,@"0",[CSDataProvider CSDataProviderShare].cardNum,[selectDic objectForKey:@"IFENDISCNUM"],pwd,[selectDic objectForKey:@"PK_ACTM"]];
    return [self PostDataApi:@"cardOutPointByPre" Data:weatherUrl1];
}
#pragma mark 取消支付
-(NSDictionary *)ZCcancelPayment
{
    NSString *pwd=[CSDataProvider CSDataProviderShare].cardWord;
    NSString *weatherUrl1=[NSString stringWithFormat:@"padid=%@&cardno=%@&password=%@&billno=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"iPadID"],[CSDataProvider CSDataProviderShare].cardNum,pwd,[CSDataProvider CSDataProviderShare].billNo];
    return [self PostDataApi:@"cancelPayment" Data:weatherUrl1];
}
#pragma mark 储值支付
-(NSDictionary *)ZCcardOutAmt
{
    NSString *pwd=[CSDataProvider CSDataProviderShare].cardWord;
    NSString *weatherUrl1=[NSString stringWithFormat:@"padid=%@&cardno=%@&pwd=%@&amt=%.2f&payment=1&nbzero=0&conacct=%@&billno=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"iPadID"],[CSDataProvider CSDataProviderShare].cardNum,pwd,_remainingAmount,[[NSUserDefaults standardUserDefaults] objectForKey:@"POSID"],[CSDataProvider CSDataProviderShare].billNo];
    return [self PostDataApi:@"cardOutAmt" Data:weatherUrl1];
}
//http://192.168.0.199:8081/CTF/webService/CRMWebService/getCardOutAmtDate?cardNo=18811111111&bdat=2014-01-01&edat=2015-03-02
#pragma mark 获取消费时间CRM
-(NSDictionary *)ZCqueryDate
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy"];
    NSString *year=[dateFormat stringFromDate:[NSDate date]];
    [dateFormat setDateFormat:@"MM-dd"];
    NSString *day=[dateFormat stringFromDate:[NSDate date]];
    NSString *bdat=[NSString stringWithFormat:@"%d-%@",[year intValue]-1,day];
    NSString *edat=[NSString stringWithFormat:@"%d-%@",[year intValue],day];
    NSString *pwd=[CSDataProvider CSDataProviderShare].cardWord;
    NSString *weatherUrl1=[NSString stringWithFormat:@"cardno=%@&bdat=%@&edat=%@",[CSDataProvider CSDataProviderShare].cardNum,bdat,edat];
    return [self PostDataApi:@"queryDate" Data:weatherUrl1];
}
#pragma mark - 查询历史账单CRM
-(NSDictionary *)ZCqueryOldOrderByCrm:(NSString *)date
{
    /**
	 * crm接口历史账单查询
	 * @param cardNo 卡号
	 * @param dateString 消费日期
	 * @return
     */
    NSString *weatherUrl1=[NSString stringWithFormat:@"cardno=%@&dateString=%@",[CSDataProvider CSDataProviderShare].cardNum,date];
    NSDictionary *dict=[self PostDataApi:@"queryOldOrderByCrm" Data:weatherUrl1];
    return dict;
}
#pragma mark - 查询历史账单
-(NSDictionary *)ZCqueryOldOrder:(NSString *)date
{
    /**
	 * crm接口历史账单查询
	 * @param cardNo 卡号
	 * @param dateString 消费日期
	 * @return
     */
    NSString *weatherUrl1=[NSString stringWithFormat:@"cardno=%@&dat=%@&padid=%@",[CSDataProvider CSDataProviderShare].cardNum,date,[[NSUserDefaults standardUserDefaults] objectForKey:@"iPadID"]];
    NSDictionary *dict=[self PostDataApi:@"queryOldOrder" Data:weatherUrl1];
    return dict;
}
/**
 *  post请求
 *
 *  @param info 参数
 *  @param api  接口
 *
 *  @return
 */
- (NSDictionary *)PostDataApi:(NSString *)api Data:(NSString *)dataInfo
{
    BSWebServiceAgent *agent = [[BSWebServiceAgent alloc] init];
    NSDictionary *dict =[agent PostDataApi:api Data:dataInfo];
    return dict;
}
/**
 *  WebService地址
 *
 *  @return
 */
-(NSString *)HMDwebServiceIP
{
    return [NSString stringWithFormat:@"http://%@:%@/ChoiceWebService/services/HHTSocket/",[[NSUserDefaults standardUserDefaults] objectForKey:@"ip"],[[NSUserDefaults standardUserDefaults] objectForKey:@"port"]];
}


+(NSString *)ZCCafeteriaWebServiceIP
{
    return [NSString stringWithFormat:@"http://%@:%@/ChoiceWebService/services/ChoiceSelfService/",[[NSUserDefaults standardUserDefaults] objectForKey:@"ip"],[[NSUserDefaults standardUserDefaults] objectForKey:@"port"]];
}
#pragma mark -
+ (NSURLSessionDataTask *)globalTimelinePosts:(NSString *)str WithBlock:(void (^)(NSDictionary *posts, NSError *error))block {
    return [[AFAppDotNetAPIClient sharedClient] GET:str parameters:nil success:^(NSURLSessionDataTask * __unused task, id XML) {
        NSDictionary *dict=[NSDictionary dictionaryWithXMLData:XML];
        if (block) {
            block([NSDictionary dictionaryWithDictionary:dict], nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSDictionary dictionary], error);
        }
    }];
}
#pragma mark - 图片
+ (UIImage *)imgWithContentsOfImageName:(NSString *)imgName{
    //    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    UIImage *img = [[UIImage alloc] init];
    img=[UIImage imageWithContentsOfFile:[imgName documentPath]];
    return img;
}
#pragma mark - MD5加密
//md5 32位 加密 （小写）
+ (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[32];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0],result[1],result[2],result[3],
            result[4],result[5],result[6],result[7],
            result[8],result[9],result[10],result[11],
            result[12],result[13],result[14],result[15],
            result[16], result[17],result[18], result[19],
            result[20], result[21],result[22], result[23],
            result[24], result[25],result[26], result[27],
            result[28], result[29],result[30], result[31]];
    
}
#pragma mark - 声音播放
+(void)playSound{
    //播放声音
    SystemSoundID audioEffect;
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"addfood" ofType :@"wav"];
    if ([[NSFileManager defaultManager] fileExistsAtPath : path])
    {
        NSURL *pathURL = [NSURL fileURLWithPath : path];
        SystemSoundID audioEffect;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
        AudioServicesPlaySystemSound(audioEffect);
    }
    else
    {
        NSLog(@"error, file not found: %@", path);
    }
    AudioServicesDisposeSystemSoundID(audioEffect);
}
#pragma mark - 中餐计算套餐价格--优惠分摊
-(NSMutableArray *)ZCcalculationPackagePrice:(NSMutableArray *)packageItem withPackage:(NSDictionary *)package
{
    float mrMoney = 0.0;//套餐明细价格汇总
    float tcMoney=[[package objectForKey:@"PRICE"] floatValue];//套餐价格
    /**
     *  计算套餐明细总价格
     */
    for (int i=0; i<[packageItem count]; i++) {
        NSDictionary *dict=[packageItem objectAtIndex:i];
        mrMoney+=[[dict objectForKey:@"PRICE"] floatValue];
    }
    
    for (int i=0; i<[packageItem count]; i++) {
        NSDictionary *dict=[packageItem objectAtIndex:i];
        float m_price1=[[dict objectForKey:@"PRICE"] floatValue];
        float tempMoney1=m_price1*tcMoney/mrMoney;
        /**
         *  套餐优惠金额
         */
        [dict setValue:[NSString stringWithFormat:@"%.2f",tempMoney1-m_price1] forKey:@"tcDisc"];
        [dict setValue:[NSString stringWithFormat:@"%.2f",tempMoney1] forKey:@"PRICE1"];
        //判断分摊之后的价格是否与套餐价格相等
        if (i==[packageItem count]-1) {
            float mrMoney1 = 0.0;
            //计算完之后价格
            for (int j=0; j<[packageItem count]; j++) {
                mrMoney1+=[[[packageItem objectAtIndex:j] objectForKey:@"PRICE1"] floatValue];
            }
            
            if (mrMoney1!=tcMoney) {
                for (int j=0; j<[packageItem count]; j++) {
                    NSDictionary *dict1=[packageItem objectAtIndex:j];
                    float x=tcMoney-mrMoney1;
                    [dict1 setValue:[NSString stringWithFormat:@"%.2f",[[dict1 objectForKey:@"tcDisc"] floatValue]+x] forKey:@"tcDisc"];
                    [dict1 setValue:[NSString stringWithFormat:@"%.2f",x] forKey:@"PRICE1"];
                    break;
                }
                
            }
        }
    }
    return packageItem;
}

@end
