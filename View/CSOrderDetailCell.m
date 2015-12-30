//
//  CSOrderDetailCell.m
//  Cafeteria
//
//  Created by chensen on 14/11/6.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import "CSOrderDetailCell.h"
#import "CSAdditionalView.h"
#import "CSAdditionalCell.h"

@implementation CSOrderDetailCell
{
    NSDictionary *_config;
    NSIndexPath  *_dataIndex;
    NSDictionary *_dataInfo;
    NSMutableArray *_additionArray;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self initView];
        
        
        //        self.backgroundColor=[UIColor blackColor];
    }
    return self;
}
/**
 *  view.tag    100   图片
                300   背景
                101   名称
                102   价格
                103   选择标记
                202   确定按钮
                203   取消按钮
 */
- (void)initView
{
    //设置位置大小
    _config=[CSDataProvider CSDataProviderShare].config;
    NSDictionary *dict=[_config objectForKey:@"FoodDetail"];
    
    self.frame = CGRectFromString([[_config objectForKey:@"FoodDetail"] objectForKey:@"FoodDetailFrame"]);
    NSLog(@"%@",[[_config objectForKey:@"FoodDetail"] objectForKey:@"FoodDetailFrame"]);
    self.backgroundColor=[UIColor colorWithRed:17/255.0 green:17/255.0 blue:17/255.0 alpha:0.9];
    //设置图片大小
    UIImageView *imgPhoto=[[UIImageView alloc] initWithFrame:CGRectFromString([dict objectForKey:@"PhotoFrame"])];
    imgPhoto.backgroundColor=[UIColor whiteColor];
    imgPhoto.tag=100;
    imgPhoto.layer.shadowColor = [UIColor blackColor].CGColor;
    imgPhoto.layer.shadowOffset = CGSizeMake(0, 0);
    imgPhoto.layer.shadowOpacity = 0.5;
    imgPhoto.layer.shadowRadius = 10.0;
    imgPhoto.userInteractionEnabled=YES;
    [self.contentView addSubview:imgPhoto];
    UILongPressGestureRecognizer *longPress =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTableviewCellLongPressed:)];
    //将长按手势添加到需要实现长按操作的视图里
    [imgPhoto addGestureRecognizer:longPress];
    //设置名称
    CGRect rect=CGRectFromString([dict objectForKey:@"NameFrame"]);
    UIView *backView=[[UIView alloc] init];
    backView.frame=CGRectMake(imgPhoto.frame.origin.x, rect.origin.y-10, imgPhoto.frame.size.width, imgPhoto.frame.size.height+imgPhoto.frame.origin.y-rect.origin.y+10);
    backView.backgroundColor=[UIColor colorWithRed:21/255.0 green:21/255.0 blue:21/255.0 alpha:0.9];
    backView.tag=300;
    [self.contentView addSubview:backView];
    UILabel *lblName=[[UILabel alloc] initWithFrame:rect];
    lblName.tag=101;
    lblName.font=[UIFont systemFontOfSize:20];
    lblName.textColor=[UIColor whiteColor];
    lblName.backgroundColor=[UIColor clearColor];
    [self.contentView addSubview:lblName];
    //设置价格
    UILabel *lblPrice=[[UILabel alloc] initWithFrame:CGRectFromString([dict objectForKey:@"PriceFrame"])];
    lblPrice.tag=102;
    lblPrice.backgroundColor=[UIColor clearColor];
    lblPrice.font=[UIFont systemFontOfSize:18];
    lblPrice.textColor=[UIColor whiteColor];
    [self.contentView addSubview:lblPrice];
    //选择的标记
    UIImageView *selectOrder=[[UIImageView alloc] initWithFrame:CGRectFromString([dict objectForKey:@"SelectTagFrame"])];
    [selectOrder setImage:[CSDataProvider imgWithContentsOfImageName:@"SelectTag.png"]];
    selectOrder.tag=103;
    selectOrder.userInteractionEnabled=YES;
    selectOrder.hidden=YES;
    [self.contentView addSubview:selectOrder];
    //设置数量
    UILabel *lblCount=[[UILabel alloc] initWithFrame:CGRectFromString([dict objectForKey:@"CountFrame"])];
    lblCount.tag=106;
//    lblCount.backgroundColor=[UIColor redColor];
    lblCount.font=[UIFont systemFontOfSize:20];
    lblCount.textColor=[UIColor redColor];
    lblCount.text=@"1";
    lblCount.backgroundColor=[UIColor clearColor];
    lblCount.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:lblCount];
    //菜品介绍
    UILabel *lblIntroduce=[[UILabel alloc] initWithFrame:CGRectZero];
    lblIntroduce.frame=CGRectFromString([dict objectForKey:@"IntroduceFrame"]);
    lblIntroduce.tag=105;
    lblIntroduce.backgroundColor=[UIColor clearColor];
    lblIntroduce.font=[UIFont systemFontOfSize:20];
    lblIntroduce.textColor=[UIColor whiteColor];
    lblIntroduce.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview:lblIntroduce];
    /**
     *  确定按钮
     */
    NSArray *buttonFrame=[[NSArray alloc] initWithObjects:[dict objectForKey:@"AddFrame"],[dict objectForKey:@"SubtractFrame"],[dict objectForKey:@"OKFrame"],[dict objectForKey:@"BackFrame"], nil];
    NSArray *buttonImage=[[NSArray alloc] initWithObjects:@"add.png",@"subtract.png",@"OKButton.png",@"CancelButton.png", nil];
    for (int i=0; i<4; i++) {
        UIButton *OkButton=[UIButton buttonWithType:UIButtonTypeCustom];
        OkButton.frame=CGRectFromString([buttonFrame objectAtIndex:i]);
        OkButton.tag=200+i;
        [OkButton setBackgroundImage:[CSDataProvider imgWithContentsOfImageName:[buttonImage objectAtIndex:i]] forState:UIControlStateNormal];
        [OkButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:OkButton];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeFrame) name:@"changeFrame" object:nil];
}

-(void)ChangeFrame
{
    _config=[CSDataProvider CSDataProviderShare].config;
    NSDictionary *dict=[_config objectForKey:@"FoodDetail"];
    self.frame = CGRectFromString([[_config objectForKey:@"FoodDetail"] objectForKey:@"FoodDetailFrame"]);
//    self.frame = CGRectFromString([[_config objectForKey:@"FoodDetail"] objectForKey:@"FoodDetailFrame"]);
    UIView *view=[self.contentView viewWithTag:100];
    view.frame=CGRectFromString([dict objectForKey:@"PhotoFrame"]);
    UIView *view1=[self.contentView viewWithTag:101];
    view1.frame=CGRectFromString([dict objectForKey:@"NameFrame"]);
    UIView *view2=[self.contentView viewWithTag:102];
    view2.frame=CGRectFromString([dict objectForKey:@"PriceFrame"]);
    view2=[self.contentView viewWithTag:300];
    CGRect rect=CGRectFromString([dict objectForKey:@"NameFrame"]);
    view2.frame=CGRectMake(view.frame.origin.x, rect.origin.y-10, view.frame.size.width, view.frame.size.height+view.frame.origin.y-rect.origin.y+10);
    UIView *view3=[self.contentView viewWithTag:103];
    
    UIView *view9=[self.contentView viewWithTag:106];
    view9.frame=CGRectFromString([dict objectForKey:@"CountFrame"]);
    
    UIView *view10=[self.contentView viewWithTag:105];
    view10.frame=CGRectFromString([dict objectForKey:@"IntroduceFrame"]);
    
    UIView *view11=[self.contentView viewWithTag:104];
    view11.frame=CGRectFromString([[_config objectForKey:@"FoodDetail"] objectForKey:@"AdditionalFrame"]);
    [view1 setExclusiveTouch:1];
    
    view3.frame=CGRectFromString([dict objectForKey:@"SelectTagFrame"]);
    UIView *view8=[self.contentView viewWithTag:200];
    view8.frame=CGRectFromString([dict objectForKey:@"AddFrame"]);
    UIView *view5=[self.contentView viewWithTag:201];
    view5.frame=CGRectFromString([dict objectForKey:@"SubtractFrame"]);
    UIView *view6=[self.contentView viewWithTag:202];
    view6.frame=CGRectFromString([dict objectForKey:@"OKFrame"]);
    UIView *view7=[self.contentView viewWithTag:203];
    view7.frame=CGRectFromString([dict objectForKey:@"BackFrame"]);
    
}
/**
 *  改变模式通知
 *
 *  @param btn
 */
-(void)buttonClick:(UIButton *)btn
{
    UILabel *lb=(UILabel *)[self viewWithTag:106];
    if (btn.tag==200) {
        lb.text=[NSString stringWithFormat:@"%d",[lb.text intValue]+1];
        [_dataInfo setValue:[NSString stringWithFormat:@"%d",[[_dataInfo objectForKey:@"total"] intValue]+1] forKey:@"total"];
    }else if(btn.tag==201){
        if ([lb.text intValue]>1) {
            lb.text=[NSString stringWithFormat:@"%d",[lb.text intValue]-1];
            [_dataInfo setValue:[NSString stringWithFormat:@"%d",[[_dataInfo objectForKey:@"total"] intValue]-1] forKey:@"total"];
        }
    }else if (btn.tag==203) {
        NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"tag",_dataIndex,@"indexPath", nil];
        if ([_dataInfo objectForKey:@"CNT"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PackageChangeModel" object:dict
             ];
        }else
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeModel" object:dict
         ];
    }else if(btn.tag==202)
    {
        NSMutableDictionary *info=[[NSMutableDictionary alloc] initWithDictionary:_dataInfo];
        CSAdditionalView *view=(CSAdditionalView *)[self viewWithTag:104];
        _additionArray=view.additionArray;
        //判断套餐明细
        if ([_dataInfo objectForKey:@"CNT"]) {
            NSMutableArray *array=[[NSMutableArray alloc] init];
            if ([CSDataProvider CSDataProviderShare].PackageItem) {
                array=[CSDataProvider CSDataProviderShare].PackageItem;
            }
            /**
             *  中餐套餐
             */
            if ([Mode isEqualToString:@"zc"]) {
                /**
                 *  判断该组是否选择了菜品
                 */
                for (NSDictionary *dict in array) {
                    if ([[dict objectForKey:@"PRODUCTTC_ORDER"] isEqualToString:[_dataInfo objectForKey:@"PRODUCTTC_ORDER"]]) {
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[CSDataProvider localizedString:@"It can choose in other food has finished, please long press cancel after dishes, then choose new dishes"] message:nil delegate:nil cancelButtonTitle:[CSDataProvider localizedString:@"OK"] otherButtonTitles:nil];
                        [alert show];
                        return;
                    }
                }
            }else
            {
                /**
                 *  判断该组菜品是否达到了最大份数
                 */
                int i=0;
                for (NSDictionary *dict in array) {
                    if ([[dict objectForKey:@"PRODUCTTC_ORDER"] isEqualToString:[_dataInfo objectForKey:@"PRODUCTTC_ORDER"]]) {
                        i+=[[dict objectForKey:@"total"] intValue];
                    }
                }
                if (i+1>[[_dataInfo objectForKey:@"TYPMAXCNT"] intValue]) {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[CSDataProvider localizedString:@"It can choose in other food has finished, please long press cancel after dishes, then choose new dishes"] message:nil delegate:nil cancelButtonTitle:[CSDataProvider localizedString:@"OK"] otherButtonTitles:nil];
                    [alert show];
                    return;
                }
            }
            
//            [info setValue:@"1" forKey:@"total"];
            NSArray *array1=[[NSArray alloc] initWithArray:_additionArray];
            [info setValue:[NSArray arrayWithArray:array1] forKey:@"addition"];
            [array addObject:info];
            [CSDataProvider CSDataProviderShare].PackageItem=array;
             UIView *view=[self viewWithTag:103];
            view.hidden=NO;

        }else
        {
            //当前点的所有的菜品
            NSMutableArray *array=[[NSMutableArray alloc] initWithArray:[CSDataProvider CSDataProviderShare].foodsArray];
            int i=0;  //菜品数量
            int j=0;  //菜品在数组里的位置
            //判断是否有附加项
            if (_additionArray&&[_additionArray count]>0) {
                [info setObject:[NSArray arrayWithArray:_additionArray] forKey:@"addition"];
            }
            //当没有附加项的时候计算出数组里的第几个是该菜品j
            if (![info objectForKey:@"addition"]&&[[info objectForKey:@"ISTC"] intValue]!=1&&[[info objectForKey:@"ISUNITS"] intValue]!=1) {
                for (NSDictionary *dict in array) {
                    if ([[dict objectForKey:@"ITCODE"] isEqualToString:[info objectForKey:@"ITCODE"]]&&![dict objectForKey:@"addition"]) {
                        i=[[dict objectForKey:@"total"] intValue];
                        break;
                    }
                    j++;
                }
            }
            
            [info setObject:[NSString stringWithFormat:@"%d",i+[[info objectForKey:@"total"] intValue]] forKey:@"total"];
            [_dataInfo setValue:[NSString stringWithFormat:@"%d",i+[[info objectForKey:@"total"] intValue]] forKey:@"count"];
            //判断是否套餐
            if([_dataInfo objectForKey:@"PACKID"]||[[_dataInfo objectForKey:@"ISTC"] intValue]==1)//套餐
            {
                [array addObject:info];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"package" object:_dataInfo];
            }else
            {
                
                if (i>0) {
                    [array removeObjectAtIndex:j];
                    [array insertObject:info atIndex:j];
                }else
                {
                    [array addObject:info];
                }
            }
            [CSDataProvider CSDataProviderShare].foodsArray=array;
            /**
             *  判断是否是多规格
             */
            if ([Mode isEqualToString:@"kc"]&&[[_dataInfo objectForKey:@"ISUNITS"] intValue]==1) {
                [self changeUnit:btn];
            }
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"updataFood" object:nil];
            [_dataInfo setValue:@"1" forKey:@"total"];
            lb.text=[NSString stringWithFormat:@"%d",1];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
            UIView *view1=[self viewWithTag:103];
            view1.hidden=NO;
        }
        
    }
}


#pragma mark - 多规格
- (void)changeUnit:(UIButton *)btn{
    
    NSDictionary *food=[[CSDataProvider CSDataProviderShare].foodsArray lastObject];
    NSMutableArray *mutmut = [NSMutableArray array];
    /**
     *  判断6个价格中那个有价格
     */
    //UNITS1-PRICE  UNITS2-PRICE5 UNITS3-PRICE6 UNITS4-PRICE7 UNITS5-PRICE8 UNITS6-PRICE9
    for (int i=0;i<6;i++){
        NSString *unit = [food objectForKey:[NSString stringWithFormat:@"UNITS%d",i+1]];
        NSString *price = [food objectForKey:0==i?@"PRICE":[NSString stringWithFormat:@"PRICE%d",i+4]];
        if (unit && [unit length]>0)
            [mutmut addObject:[NSDictionary dictionaryWithObjectsAndKeys:price,@"price",unit,@"unit", nil]];
    }
    
    if ([mutmut count]>1){
        NSMutableArray *mut = [NSMutableArray array];
        for (int j=0;j<[mutmut count];j++){
            NSString *title = [NSString stringWithFormat:@"%d元/%@",[[[mutmut objectAtIndex:j] objectForKey:@"price"] intValue],[[mutmut objectAtIndex:j] objectForKey:@"unit"]];
            [mut addObject:title];
        }
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择单位"   delegate:self
                                                  cancelButtonTitle:nil
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:nil];
        // 逐个添加按钮（比如可以是数组循环）
        for (NSString *str in mut) {
            [sheet addButtonWithTitle:str];
        }
        sheet.delegate=self;
        [sheet showFromRect:btn.frame inView:self animated:YES];
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[[CSDataProvider CSDataProviderShare].foodsArray lastObject] setValue:@"1" forKey:@"UNITKAY"];
    //如果是选择的是第一个不需要修改
    if (buttonIndex!=0) {
        int j = 0;
        for (int i=0;i<6;i++){
            NSString *unit = [_dataInfo objectForKey:[NSString stringWithFormat:@"UNITS%d",i+1]];
            if (unit && [unit length]>0){
                if (j==buttonIndex) {
                    [[[CSDataProvider CSDataProviderShare].foodsArray lastObject] setValue:unit forKey:@"UNIT"];
//                    [_dataInfo setValue:unit forKey:@"UNIT"];
                    [[[CSDataProvider CSDataProviderShare].foodsArray lastObject] setValue:[NSNumber numberWithInt:i+1] forKey:@"UNITKAY"];
                    [[[CSDataProvider CSDataProviderShare].foodsArray lastObject] setValue:[_dataInfo objectForKey:[NSString stringWithFormat:@"PRICE%d",i+4]] forKey:@"PRICE"];
                    break;
                }
                j++;
            }
            
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
}

#pragma mark - 长按删除
//长按事件
- (void)handleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer
{
    switch (gestureRecognizer.state)
    {
            
        case UIGestureRecognizerStateEnded:
            NSLog(@"1");
            
            break;
            
        case UIGestureRecognizerStateCancelled:
            NSLog(@"2");
            break;
            
        case UIGestureRecognizerStateFailed:
            NSLog(@"123");
            break;
            
        case UIGestureRecognizerStateBegan:
        {
            if([[_dataInfo objectForKey:@"count"] intValue]>0){
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[CSDataProvider localizedString:@"You confirm to delete items instead?"] message:nil delegate:self cancelButtonTitle:[CSDataProvider localizedString:@"Cancel"] otherButtonTitles:[CSDataProvider localizedString:@"OK"], nil];
                alert.tag=100;
                [alert show];
            }
        }
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            NSLog(@"5");
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 更新数据
- (void)setDataForView:(NSDictionary *)info withIndexPath:(NSIndexPath *)indexPath;

{
    _dataIndex=indexPath;
    _dataInfo=[NSMutableDictionary dictionaryWithDictionary:info];
    UIImageView *titleIV = (UIImageView *)[self viewWithTag:100];//图片
    
    [titleIV setImage:[UIImage imageWithContentsOfFile:[[info objectForKey:@"picBig"]!=nil?[info objectForKey:@"picBig"]:[info objectForKey:@"PICBIG"] documentPath]]];
    UILabel *titleL = (UILabel *)[self viewWithTag:101];//名称
    [titleL setTextAlignment:NSTextAlignmentCenter];
    titleL.text = [info objectForKey:@"DES"];
    titleL=(UILabel *)[self viewWithTag:102];
    [titleL setTextAlignment:NSTextAlignmentCenter];
    titleL.text =[NSString stringWithFormat:@"%@ 元/%@",[info objectForKey:@"PRICE"],[info objectForKey:@"UNIT"]];//价格单位
    
    [_dataInfo setValue:@"1" forKey:@"total"];
    //判断是否被选择过
    UIView *view=[self viewWithTag:103];
    view.hidden=YES;
    
    /**
     *  套餐明细判断
     */
    if ([_dataInfo objectForKey:@"CNT"]) {
        for (NSDictionary *dict in [CSDataProvider CSDataProviderShare].PackageItem){
            if ([[dict objectForKey:@"ITCODE"]isEqualToString:[_dataInfo objectForKey:@"ITCODE"]]&&[[dict objectForKey:@"PRODUCTTC_ORDER"] isEqualToString:[_dataInfo objectForKey:@"PRODUCTTC_ORDER"]]) {
                /**
                 *  如果有选择的就显示
                 */
                view.hidden=NO;
                break;
            }
        }
    }
    else
    {
        /**
         *  单品判断
         */
        for (NSDictionary *dict in [CSDataProvider CSDataProviderShare].foodsArray){
            /**
             *  如果有选择的就显示
             */
            if ([[dict objectForKey:@"ITEM"]isEqualToString:[_dataInfo objectForKey:@"ITEM"]]) {
                view.hidden=NO;
                break;
            }
        }
    }
    //附加项设置
    view=[self.contentView viewWithTag:104];
    if (view) {
        [view removeFromSuperview];
        view=nil;
    }
    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[CSAdditionalView class]]) {
            [view removeFromSuperview];
            break;
        }
    }
    CSAdditionalView *addition=[[CSAdditionalView alloc] initWithFrame:CGRectFromString([[_config objectForKey:@"FoodDetail"] objectForKey:@"AdditionalFrame"]) withItcode:[info objectForKey:@"ITCODE"]];
    addition.tag=104;
    [self.contentView addSubview:addition];
    view=[self.contentView viewWithTag:200];//加按钮
    UIView *view1=[self.contentView viewWithTag:201];//减按钮
    UILabel *view2=(UILabel *)[self.contentView viewWithTag:106];//数量
    view2.text=@"1";
    view.hidden=NO;
    view1.hidden=NO;
    view2.hidden=NO;
    if ([[_dataInfo objectForKey:@"ISTC"] intValue]==1||[_dataInfo objectForKey:@"CNT"]) {
        view.hidden=YES;
        view1.hidden=YES;
        view2.hidden=YES;
    }
}

#pragma mark - AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==100) {
        if (buttonIndex==1) {
            /**
             *  删除菜品
             */
            //如果是套餐明细
            if ([_dataInfo objectForKey:@"PRODUCTTC_ORDER"]) {
            A:
                for (NSDictionary *dic in [CSDataProvider CSDataProviderShare].PackageItem) {
                    /**
                     *  判断编码和层相同的去删除
                     */
                    if ([[dic objectForKey:@"ITCODE"] isEqualToString:[_dataInfo objectForKey:@"ITCODE"]]&&[[dic objectForKey:@"PRODUCTTC_ORDER"] isEqualToString:[_dataInfo objectForKey:@"PRODUCTTC_ORDER"]]) {
                        NSMutableArray *package=[CSDataProvider CSDataProviderShare].PackageItem;
                        [package removeObject:dic];
                        [CSDataProvider CSDataProviderShare].PackageItem=package;
                        goto A;
                        break;
                    }
                    
                }
                /**
                 *  刷新套餐界面
                 */
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PackagereloadData" object:nil];
            }
            else
            {
                //如果是普通的菜品
            B:
                for (NSDictionary *dic in [CSDataProvider CSDataProviderShare].foodsArray) {
                    //判断编码相同删除
                    if ([[dic objectForKey:@"ITCODE"] isEqualToString:[_dataInfo objectForKey:@"ITCODE"]]) {
                        NSMutableArray *food=[CSDataProvider CSDataProviderShare].foodsArray;
                        [food removeObject:dic];
                        [CSDataProvider CSDataProviderShare].foodsArray=food;
                        goto B;
                        break;
                    }
                }
                //刷新全部的
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
            }
        //被选择的标记隐藏
        UIView *view=[self viewWithTag:103];
        view.hidden=YES;
        }
    }
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
