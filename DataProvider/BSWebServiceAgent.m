//
//  CVWebServiceAgent.m
//  CapitalVueHD
//
//  Created by jishen on 8/23/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "BSWebServiceAgent.h"
#import "SBJSON.h"
#import "XMLDictionary.h"
#import "CSDataProvider.h"

@interface BSWebServiceAgent()


@end

@implementation BSWebServiceAgent


-(id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}


#pragma mark - URL拼接
- (NSString *)serviceUrl:(NSString *)api arg:(NSString *)arg{
    NSString *str = [NSString stringWithFormat:@"http://%@/ChoiceWebService/services/ChoiceSelfService",[CSDataProvider ZCCafeteriaWebServiceIP]];
    return [NSString stringWithFormat:@"%@/%@%@",str,api,arg];
}



#pragma mark - GET请求
- (NSDictionary *)GetData:(NSString *)api arg:(NSString *)arg {
	NSString *strUrl;
	strUrl = [self serviceUrl:api arg:arg];
	return [self parseXML:strUrl];
}


#pragma mark - XML解析
-(NSDictionary *)parseXML:(NSString *)serviceUrl {
    NSDictionary *dicInfo = nil;
    
    NSURL *url = nil;
    NSMutableURLRequest *request = nil;
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *serviceData = nil;
    
    url = [[NSURL alloc] initWithString:[serviceUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    request = [[NSMutableURLRequest alloc] initWithURL:url
                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                       timeoutInterval:30.0];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"gzip" forHTTPHeaderField:@"accept-encoding"];
    
    serviceData = [NSURLConnection sendSynchronousRequest:request
                                        returningResponse:&response
                                                    error:&error];
    // 1001 is the error code for a connection timeout
    if (error && [error code]==-1001 ) {
        NSLog( @"Server timeout!" );
        //        [self showAlert];
    } else if (serviceData) {
    }
	return dicInfo;
}

#pragma mark - PUST请求
- (NSDictionary *)PostDataApi:(NSString *)api Data:(NSString *)dataInfo
{
    //第一步，创建URL
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[CSDataProvider ZCCafeteriaWebServiceIP],api]];
    
    //第二步，创建请求
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSLog(@"%@?%@",url,dataInfo);
    
    NSData *data = [dataInfo dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (!received) {
        return nil;
    }
    NSDictionary *dicInfo1 = [NSDictionary dictionaryWithXMLData:received];
    NSDictionary *dic=nil;
    if (dicInfo1) {
        NSData *jsonData = [[dicInfo1 objectForKey:@"ns:return"] dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        if (!jsonData) {
            return nil;
        }else
        dic = [[NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&err] objectForKey:@"result"];
    }
    //        NSDictionary *dict=[dicInfo1 objectForKey:@"ns:return"];
    return dic;
}
- (void)showAlert

{
    
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"网络连接超时请重试" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [promptAlert show];
    [NSTimer scheduledTimerWithTimeInterval:0.5
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:NO];
    
    
}
- (void)timerFireMethod:(UIAlertView*)theTimer
{
    [theTimer dismissWithClickedButtonIndex:0 animated:NO];
    
    theTimer =NULL;
}


@end
