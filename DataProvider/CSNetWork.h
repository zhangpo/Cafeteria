//
//  CSNetWork.h
//  Cafeteria
//
//  Created by chensen on 15/2/7.
//  Copyright (c) 2015年 Choicesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSNetWork : NSObject
-(void)ChineseFoodSendOrder;                    //发送
+(CSNetWork *)shareCSNetWork;
- (NSDictionary *)ChineseFoodQueryOrder:(NSString *)mark;  //查账单
-(NSDictionary *)ZCqueryVip;
@end
