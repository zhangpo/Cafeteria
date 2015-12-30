//
//  CVWebServiceAgent.h
//  CapitalVueHD
//
//  Created by jishen on 8/23/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "NSString+Encrypt.h"
#import <stdlib.h>


@interface BSWebServiceAgent : NSObject

- (NSDictionary *)GetData:(NSString *)api arg:(NSString *)arg;
- (NSDictionary *)PostDataApi:(NSString *)api Data:(NSString *)dataInfo;

@end
