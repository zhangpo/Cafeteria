//
//  CSLogTableViewCell.m
//  Cafeteria
//
//  Created by chensen on 14/11/13.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import "CSLogTableViewCell.h"
#import "NSObject+SBJSON.h"

@implementation TableViewCellBackgroundView
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setBackgroundColor:[UIColor redColor]];
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    CGContextRef cont = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(cont, [UIColor lightGrayColor].CGColor);
    CGContextSetLineWidth(cont, 1);
    CGFloat lengths[] = {2,2};
    CGContextSetLineDash(cont, 0, lengths, 2);  //画虚线
    CGContextBeginPath(cont);
    CGContextMoveToPoint(cont, 0.0, rect.size.height - 1);    //开始画线
    CGContextAddLineToPoint(cont, 320.0, rect.size.height - 1);
    CGContextStrokePath(cont);
}
@end
@implementation CSLogTableViewCell
{
    NSMutableDictionary *_dataDic;
    int _tag;
}
@synthesize delegate=_delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        /**
         *  设置虚线
         */
        TableViewCellBackgroundView *backgroundView = [[TableViewCellBackgroundView alloc] initWithFrame:CGRectZero];
        backgroundView.backgroundColor=[UIColor clearColor];
        [self setBackgroundView:backgroundView];
        NSDictionary *dict=[[[CSDataProvider loadData] objectForKey:@"Horizontal"] objectForKey:@"TableViewCell"];
        //菜品号
        UILabel *_foodNum=[[UILabel alloc] initWithFrame:CGRectFromString([dict objectForKey:@"NumberFrame"])];
        [self.contentView addSubview:_foodNum];
        self.backgroundColor=[UIColor clearColor];
        //菜品名称
        UILabel *_foodName=[[UILabel alloc] initWithFrame:CGRectFromString([dict objectForKey:@"NameFrame"])];
        _foodName.tag=201;
        _foodName.font=[UIFont systemFontOfSize:25];
        [self.contentView addSubview:_foodName];
        //菜品数量
        UILabel *_foodCount=[[UILabel alloc] initWithFrame:CGRectFromString([dict objectForKey:@"CountFrame"])];
        _foodCount.textAlignment=NSTextAlignmentCenter;
        _foodCount.tag=202;
        
        [self.contentView addSubview:_foodCount];
        //菜品附加项
        UILabel *_addition=[[UILabel alloc] initWithFrame:CGRectFromString([dict objectForKey:@"AdditionFrame"])];
        _addition.textAlignment=NSTextAlignmentCenter;
        _addition.textColor=[UIColor redColor];
        _addition.numberOfLines=0;
        _addition.lineBreakMode = NSLineBreakByWordWrapping;
        _addition.tag=203;
        [self.contentView addSubview:_addition];
        //加按钮
        UIButton *addButton=[UIButton buttonWithType:UIButtonTypeCustom];
        addButton.frame=CGRectFromString([dict objectForKey:@"AddFrame"]);
        [addButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [addButton setImage:[CSDataProvider imgWithContentsOfImageName:@"add.png"] forState:UIControlStateNormal];
        addButton.tag=100;
        [self.contentView addSubview:addButton];
        //减按钮
        UIButton *subtractButton=[UIButton buttonWithType:UIButtonTypeCustom];
        subtractButton.frame=CGRectFromString([dict objectForKey:@"SubtractFrame"]);
        subtractButton.tag=101;
        [subtractButton setImage:[CSDataProvider imgWithContentsOfImageName:@"subtract.png"] forState:UIControlStateNormal];
        [subtractButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:subtractButton];
        //催菜
        UIButton *urgeButton=[UIButton buttonWithType:UIButtonTypeCustom];
        urgeButton.frame=CGRectFromString([dict objectForKey:@"UrgeFrame"]);
        urgeButton.tag=102;
        [urgeButton setImage:[CSDataProvider imgWithContentsOfImageName:@"urge.png"] forState:UIControlStateNormal];
        [urgeButton addTarget:self action:@selector(urgeFood:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:urgeButton];
    }
    return self;
}
#pragma mark - 催菜
-(void)urgeFood:(UIButton *)btn
{
    NSMutableDictionary *rootDic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSArray arrayWithObjects:[_dataDic objectForKey:@"SERIAL"], nil],@"serials",[[NSUserDefaults standardUserDefaults] objectForKey:@"iPadID"],@"padid",[CSDataProvider CSDataProviderShare].cardNum,@"user",[_dataDic objectForKey:@"CODE"],@"order", nil];

    NSString *weatherUrl1=[NSString stringWithFormat:@"%@gofood?data=%@",[CSDataProvider ZCCafeteriaWebServiceIP],[rootDic JSONRepresentation]];
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
        NSDictionary *dict = [[NSJSONSerialization JSONObjectWithData:jsonData
                                                              options:NSJSONReadingMutableContainers
                                                                error:&err] objectForKey:@"result"];
        if(err) {
            NSLog(@"json解析失败：%@",err);
        }else
        {
            if ([[dict objectForKey:@"state"] intValue]==1) {
                [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"msg"]];
            }else
            {
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"msg"]];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络连接超时"];
    }];
    [operation1 start];
}
/**
 *  加减按钮事件
 *
 *  @param btn
 */
#pragma mark - 加减按钮
-(void)btnClick:(UIButton *)btn
{
    
    if (btn.tag==100) {//加事件
        [_dataDic setObject:[NSString stringWithFormat:@"%d",[[_dataDic objectForKey:@"total"] intValue]+1] forKey:@"total"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
    }else//减事件
    {
        if ([[_dataDic objectForKey:@"total"] intValue]-1>0) {
            [_dataDic setObject:[NSString stringWithFormat:@"%d",[[_dataDic objectForKey:@"total"] intValue]-1] forKey:@"total"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
        }else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"你确定要移除这个菜品吗" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认",nil];
            alert.tag=300;
            [alert show];
        }
        
    }
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==300) {
        if (buttonIndex==1) {
            NSDictionary *dict=_dataDic;
            NSMutableArray *array=[CSDataProvider CSDataProviderShare].foodsArray;
            //判断套餐
            if (([[dict objectForKey:@"ISTC"] intValue]==1||[dict objectForKey:@"PACKID"])&&[[dict objectForKey:@"ISSHOW"] isEqualToString:@"Y"]) {
                NSIndexSet *set=[[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange (_tag+1, [[dict objectForKey:@"combo"] count])];
                [dict setValue:@"N" forKey:@"ISSHOW"];
                [array removeObjectsAtIndexes:set];
            }
            [CSDataProvider CSDataProviderShare].foodsArray=array;
            [array removeObjectAtIndex:_tag];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
        }
    }
//     [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
}
#pragma mark - 显示附加项
-(void)setLogDataAddition:(NSDictionary *)info withIndex:(NSIndexPath *)indexPath withTag:(int)tag
{
    _tag=tag;
    UILabel *label=(UILabel *)[self viewWithTag:201];
    UIView *view=[self viewWithTag:100];
    view.hidden=NO;
    view=[self viewWithTag:101];
    view.hidden=NO;
    if ([info objectForKey:@"CNT"]) {
        label.text=[NSString stringWithFormat:@"---%@",[info objectForKey:@"DES"]];
        UIView *view=[self viewWithTag:100];
        view.hidden=YES;
        view=[self viewWithTag:101];
        view.hidden=YES;
    }else
    label.text=[NSString stringWithFormat:@"%d.%@",tag+1,[info objectForKey:@"DES"]];
    label=(UILabel *)[self viewWithTag:202];
    label.text=[info objectForKey:@"total"];
    label=(UILabel *)[self viewWithTag:203];
    NSMutableString *strAdditon=[NSMutableString string];
    
    if ([info objectForKey:@"addition"]) {
        for (NSDictionary *dict in [info objectForKey:@"addition"]) {
            if ([Mode isEqualToString:@"zc"]) {
                [strAdditon appendFormat:@"%@,",[dict objectForKey:@"DES"]];
            }else
            {
                [strAdditon appendFormat:@"%@,",[dict objectForKey:@"FNAME"]];
            }
            
        }
    }else
    {
        [strAdditon appendString:@"附加项"];
    }
    label.text=strAdditon;
    view=[self viewWithTag:102];
    [view removeFromSuperview];
    view=nil;
    _dataDic=info;
    
}
#pragma mark - 显示价格
-(void)setLogDataPrice:(NSDictionary *)info withTag:(int)tag
{
    UILabel *label=(UILabel *)[self viewWithTag:201];
    UIView *view=[self viewWithTag:100];
    view.hidden=NO;
    view=[self viewWithTag:101];
    view.hidden=NO;
    view=[self viewWithTag:100];
    view.hidden=YES;
    view=[self viewWithTag:101];
    view.hidden=YES;
    label.text=[NSString stringWithFormat:@"%d.%@",tag+1,[info objectForKey:@"ITEMDES"]];
    if ([[info objectForKey:@"TAG"] isEqualToString:@"PACKITEM"]) {
        label.text=[NSString stringWithFormat:@"---%@",[info objectForKey:@"ITEMDES"]];
    }
    label=(UILabel *)[self viewWithTag:202];
    label.text=[info objectForKey:@"CNT"];
    label=(UILabel *)[self viewWithTag:203];
    label.text=[NSString stringWithFormat:@"%.2f",[[info objectForKey:@"AMT"] floatValue]];
    label.textAlignment=NSTextAlignmentRight;
    view=[self viewWithTag:102];
    view.hidden=YES;
    _dataDic=info;
}
#pragma mark - 显示催菜
-(void)setLogDataUrge:(NSDictionary *)info withTag:(int)tag
{
    UILabel *label=(UILabel *)[self viewWithTag:201];
    UIView *view=[self viewWithTag:100];
    view.hidden=YES;
    view=[self viewWithTag:101];
    view.hidden=YES;
    view=[self viewWithTag:102];
    view.hidden=NO;
    view=[self viewWithTag:202];
    view.hidden=YES;
    label.text=[NSString stringWithFormat:@"%d.%@",tag+1,[info objectForKey:@"ITEMDES"]];
    if ([[info objectForKey:@"TAG"] isEqualToString:@"PACKITEM"]) {
        label.text=[NSString stringWithFormat:@"---%@",[info objectForKey:@"ITEMDES"]];
    }
    label=(UILabel *)[self viewWithTag:202];
    label.text=[info objectForKey:@"CNT"];
    label=(UILabel *)[self viewWithTag:203];
    NSMutableString *strAdditon=[NSMutableString string];
    if ([info objectForKey:@"addition"]) {
        for (NSDictionary *dict in [info objectForKey:@"addition"]) {
            if ([Mode isEqualToString:@"zc"]) {
                [strAdditon appendFormat:@"%@,",[dict objectForKey:@"DES"]];
            }else
            {
                [strAdditon appendFormat:@"%@,",[dict objectForKey:@"FNAME"]];
            }
            
        }
    }else
    {
        [strAdditon appendString:@"附加项"];
    }
    label.text=strAdditon;
    view=[self viewWithTag:102];
    _dataDic=info;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
