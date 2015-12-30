//
//  CSQueryView.m
//  Cafeteria
//
//  Created by chensen on 14/12/26.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import "CSQueryView.h"
#import "CSLogTableViewCell.h"
#import "CSDataProvider.h"

@implementation CSQueryView
{
    UITableView *_tableView;
    NSMutableArray *foodArray;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSDictionary *dict=[[CSDataProvider CSDataProviderShare].config objectForKey:@"Query"];
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectFromString([dict objectForKey:@"ViewFrame"])];
        [imageView setImage:[CSDataProvider imgWithContentsOfImageName:[dict objectForKey:@"BackgroundImage"]]];
        imageView.tag=100;
        [self addSubview:imageView];
        _tableView=[[UITableView alloc] initWithFrame:CGRectFromString([dict objectForKey:@"TableViewFrame"]) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.tag=102;
        _tableView.dataSource=self;
        _tableView.backgroundColor=[UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;  // etch是腐蚀的意思，这样设置会使分隔线为虚线，但这种风格只对table view style 为 UITableViewStyleGrouped  有效
        [self addSubview:_tableView];
//        [self ChineseFoodQueryOrder];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeFrame) name:@"changeFrame" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChineseFoodQueryOrder) name:@"ChineseFoodQueryOrder" object:nil];
    }
    return self;
}
-(void)ChineseFoodQueryOrder
{
    NSDictionary *dict =[[CSDataProvider CSDataProviderShare] ChineseFoodQueryOrder:@"2"];
    if ([[dict objectForKey:@"state"] intValue]==1) {
        NSMutableArray *foodAry=[dict objectForKey:@"foodList"];
        if (foodArray) {
            [foodArray removeAllObjects];
            foodArray=nil;
        }
        foodArray=[[NSMutableArray alloc] init];
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
                [foodArray addObject:packDic];
                
            }
            if ([[food objectForKey:@"PACKID"] intValue]==0) {
                [foodArray addObject:food];
            }
        }
        [_tableView reloadData];
    }
//    NSString *weatherUrl1=[NSString stringWithFormat:@"%@queryOrder?padid=%@&tableinit=%@&mark=%@",[CSDataProvider ZCCafeteriaWebServiceIP],[[NSUserDefaults standardUserDefaults] objectForKey:@"iPadID"],[[NSUserDefaults standardUserDefaults] objectForKey:@"POSID"],@"3"];
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
//        NSDictionary *dict = [[NSJSONSerialization JSONObjectWithData:jsonData
//                                                             options:NSJSONReadingMutableContainers
//                                                               error:&err] objectForKey:@"result"];
//        if(err) {
//            NSLog(@"json解析失败：%@",err);
//        }else
//        {
//            if ([[dict objectForKey:@"state"] intValue]==1) {
//                NSMutableArray *foodAry=[[dict objectForKey:@"msg"] objectForKey:@"foodList"];
//                if (foodArray) {
//                    [foodArray removeAllObjects];
//                    foodArray=nil;
//                }
//                foodArray=[[NSMutableArray alloc] init];
//                for (NSDictionary *food in foodAry) {
//                    if ([[food objectForKey:@"PACKID"] intValue]>0&&[[food objectForKey:@"PACKINDEX"] intValue]==1) {
//                        NSMutableArray *packAry=[[NSMutableArray alloc] init];
//                        NSMutableDictionary *packDic=[[NSMutableDictionary alloc] init];
//                        [packDic setObject:[food objectForKey:@"PACKAGEDES"] forKey:@"ITEMDES"];
//                        [packDic setObject:[food objectForKey:@"PACKPRICE"] forKey:@"AMT"];
//                        [packDic setObject:@"PACKAGE" forKey:@"TAG"];
//                        [packDic setObject:@"1" forKey:@"CNT"];
//                        for (NSDictionary *foodDic in foodAry) {
//                            if ([[foodDic objectForKey:@"PACKID"] isEqualToString:[food objectForKey:@"PACKID"]]&&[[foodDic objectForKey:@"PKGTAG"] isEqualToString:[food objectForKey:@"PKGTAG"]]) {
//                                //                        [foodDic setObject:@"PACKITEM" forKey:@"TAG"];
//                                [foodDic setValue:@"PACKITEM" forKey:@"TAG"];
//                                [packAry addObject:foodDic];
//                            }
//                        }
//                        [packDic setObject:packAry forKey:@"combo"];
//                        [foodArray addObject:packDic];
//                        
//                    }
//                    if ([[food objectForKey:@"PACKID"] intValue]==0) {
//                        [foodArray addObject:food];
//                    }
//                }
//                [_tableView reloadData];
//            }else
//            {
//                [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"msg"]];
//            }
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"网络连接超时"];
//    }];
//    [operation1 start];
}


-(void)ChangeFrame
{
    NSDictionary *dict=[[CSDataProvider CSDataProviderShare].config objectForKey:@"Query"];
    UIImageView *image=(UIImageView *)[self viewWithTag:100];
    image.frame=CGRectFromString([dict objectForKey:@"ViewFrame"]);
    [image setImage:[CSDataProvider imgWithContentsOfImageName:[dict objectForKey:@"BackgroundImage"]]];
    UIView *view=[self viewWithTag:102];
    view.frame=CGRectFromString([dict objectForKey:@"TableViewFrame"]);
    
}
#pragma mark - tableViewDelegate&&tableViewdataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [foodArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName=@"cellName";
    CSLogTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell=[[CSLogTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
    }
    [cell setLogDataUrge:[foodArray objectAtIndex:indexPath.row] withTag:indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize rect=CGSizeFromString([[[CSDataProvider CSDataProviderShare].config objectForKey:@"Query"] objectForKey:@"OrderSize"]);
    return rect.height;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  判断套餐，如果是套餐点击展开显示明细
     */
        NSMutableArray *array=foodArray;
        NSDictionary *dict=[array objectAtIndex:indexPath.row];
        if ([dict objectForKey:@"TAG"]&&[[dict objectForKey:@"TAG"] isEqualToString:@"PACKAGE"])
        {
            if (![[dict objectForKey:@"ISSHOW"]isEqualToString:@"Y"]) {
                NSIndexSet *set=[[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange (indexPath.row+1, [[dict objectForKey:@"combo"] count])];
                [dict setValue:@"Y" forKey:@"ISSHOW"];
                NSArray *array1=[NSArray arrayWithArray:[dict objectForKey:@"combo"]];
                for (NSDictionary *dic in array1) {
                    [dic setValue:@"" forKey:@"total"];
                }
                [array insertObjects:array1 atIndexes:set];
            }else if (![[dict objectForKey:@"ISSHOW"]isEqualToString:@"N"])
            {
                NSIndexSet *set=[[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange (indexPath.row+1, [[dict objectForKey:@"combo"] count])];
                [dict setValue:@"N" forKey:@"ISSHOW"];
                [array removeObjectsAtIndexes:set];
                //            [array insertObjects:[dict objectForKey:@"combo"] atIndexes:set];
            }
        }
        [CSDataProvider CSDataProviderShare].foodQueryArray=array;
        [_tableView reloadData];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
