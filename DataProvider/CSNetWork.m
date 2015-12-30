//
//  CSNetWork.m
//  Cafeteria
//
//  Created by chensen on 15/2/7.
//  Copyright (c) 2015年 Choicesoft. All rights reserved.
//

#import "CSNetWork.h"
#import "CSDataProvider.h"
#import "AFNetworking.h"
#import "XMLDictionary.h"
#import "SVProgressHUD.h"

@implementation CSNetWork

static CSNetWork *_shareCSNetWork;
+(CSNetWork *)shareCSNetWork
{
    if (!_shareCSNetWork) {
        _shareCSNetWork=[[CSNetWork alloc] init];
    }
    return _shareCSNetWork;
}

#pragma mark - 中餐发送菜品请求
-(void)ChineseFoodSendOrder
{
    NSString *weatherUrl1=[NSString stringWithFormat:@"%@orderFood?data=%@",[CSDataProvider ZCCafeteriaWebServiceIP],[[CSDataProvider CSDataProviderShare] ZCCafeteriaSendFoodString]];
    NSLog(@"%@",weatherUrl1);
    NSURLRequest* request1 = [NSURLRequest requestWithURL:[NSURL URLWithString:[weatherUrl1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    AFHTTPRequestOperation* operation1 = [[AFHTTPRequestOperation alloc] initWithRequest:request1];
    //设置下载完成调用的block
    [operation1 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dicInfo1 = [NSDictionary dictionaryWithXMLData:operation.responseData];
        [SVProgressHUD dismiss];
        //        NSDictionary *dict=[dicInfo1 objectForKey:@"ns:return"];
        NSData *jsonData = [[dicInfo1 objectForKey:@"ns:return"] dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [[NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&err] objectForKey:@"result"];
        if(err) {
            NSLog(@"json解析失败：%@",err);
        }else
        {
            if ([[dic objectForKey:@"state"] intValue]==1) {
                [CSDataProvider CSDataProviderShare].foodsArray=nil;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
                [SVProgressHUD showSuccessWithStatus:[dic objectForKey:@"msg"]];
            }else
            {
                [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"msg"]];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络连接超时"];
    }];
    [operation1 start];
}
#pragma mark - 中餐查询账单接口
- (NSDictionary *)ChineseFoodQueryOrder:(NSString *)mark
{
    NSString *url=[NSString stringWithFormat:@"%@queryOrder?padid=%@&tableinit=%@&mark=%@",[CSDataProvider ZCCafeteriaWebServiceIP],[[NSUserDefaults standardUserDefaults] objectForKey:@"iPadID"],[[NSUserDefaults standardUserDefaults] objectForKey:@"POSID"],mark];
    NSLog(@"%@",url);
    NSDictionary *dict=[self webServiceUrl:url];
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
    
    return [NSDictionary dictionaryWithObjectsAndKeys:[dict objectForKey:@"state"],@"state",showArray,@"foodList",[[dict objectForKey:@"msg"] objectForKey:@"payment"],@"payment", nil];
}
#pragma mark - 会员信息查询
-(NSDictionary *)ZCqueryVip
{
    NSString *url=[NSString stringWithFormat:@"%@queryVip?padid=%@&cardno=%@",[CSDataProvider ZCCafeteriaWebServiceIP],[[NSUserDefaults standardUserDefaults] objectForKey:@"iPadID"],[CSDataProvider CSDataProviderShare].cardNum];
    NSDictionary *dict=[self webServiceUrl:url];
    NSLog(@"%@",url);
    return dict;
    
}
//阻塞
#pragma mark - 调用接口
- (NSDictionary *)webServiceUrl:(NSString *)url
{
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:@"get" URLString:url parameters:nil error:nil];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFHTTPResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    [requestOperation setResponseSerializer:responseSerializer];
    [requestOperation start];
    [requestOperation waitUntilFinished];
    NSDictionary *dicInfo1 = [NSDictionary dictionaryWithXMLData:requestOperation.responseData];
    NSData *jsonData = [[dicInfo1 objectForKey:@"ns:return"] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [[NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&err] objectForKey:@"result"];
    return dic;
}

//-(void)ChineseFoodQueryOrder:(NSString *)mark
//{
//    
//    NSString *weatherUrl1=[NSString stringWithFormat:@"%@queryOrder?padid=%@&tableinit=%@&mark=%@",[CSDataProvider ZCCafeteriaWebServiceIP],[[NSUserDefaults standardUserDefaults] objectForKey:@"iPadID"],[[NSUserDefaults standardUserDefaults] objectForKey:@"POSID"],@"2"];
//    NSLog(@"%@",weatherUrl1);
//    NSURLRequest* request1 = [NSURLRequest requestWithURL:[NSURL URLWithString:[weatherUrl1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
//    AFHTTPRequestOperation* operation1 = [[AFHTTPRequestOperation alloc] initWithRequest:request1];
//    //设置下载完成调用的block
//    [operation1 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *dicInfo1 = [NSDictionary dictionaryWithXMLData:operation.responseData];
//        [SVProgressHUD dismiss];
//        //        NSDictionary *dict=[dicInfo1 objectForKey:@"ns:return"];
//        NSData *jsonData = [[dicInfo1 objectForKey:@"ns:return"] dataUsingEncoding:NSUTF8StringEncoding];
//        NSError *err;
//        NSDictionary *dic = [[NSJSONSerialization JSONObjectWithData:jsonData
//                                                             options:NSJSONReadingMutableContainers
//                                                               error:&err] objectForKey:@"result"];
//        if(err) {
//            NSLog(@"json解析失败：%@",err);
//        }else
//        {
//            if ([[dic objectForKey:@"state"] intValue]==1) {
//                if ([[[dic objectForKey:@"msg"] objectForKey:@"foodList"] count]>0) {
//                    [CSDataProvider CSDataProviderShare].foodQueryArray=[[dic objectForKey:@"msg"] objectForKey:@"foodList"];
//                }else
//                {
//                    if ([CSDataProvider CSDataProviderShare].foodsArray) {
//                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"你是否要发送选择的菜品" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
//                        alert.tag=100;
//                        [alert show];
//                    }else
//                    {
//                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"请点完菜品后进行该操作" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                        [alert show];
//                    }
//                }
//                
//            }else
//            {
//                [SVProgressHUD showErrorWithStatus:@"查询失败"];
//            }
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"网络连接超时"];
//    }];
//    [operation1 start];
//
//}

@end
