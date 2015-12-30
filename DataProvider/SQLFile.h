//
//  SQLFile.h
//  Cafeteria
//
//  Created by chensen on 15/3/17.
//  Copyright (c) 2015年 Choicesoft. All rights reserved.
//

#ifndef Cafeteria_SQLFile_h
#define Cafeteria_SQLFile_h

#pragma mark - 查询全部的菜品
#define SELECT_ALLFOOD  @"select * from food"

#pragma mark - 查询全部的菜品的外带价格
#define SELECT_TOGOFOOD @"select *,PRICE2 as PEICE from food"

#pragma mark - 查询菜品多语言
#define SELECT_LANGUAG  @"select PNAME from LANGUAGEDICT where pcode='%@' and trtype='%@'"

#pragma mark - 查询券活动
#define SELECT_PREFERENTIAL @"SELECT PK_ACTM FROM ACTM where VVOUCHERCODE=%@"

#pragma mark - 查询积分活动
#define SELECT_INTEGRAL @"SELECT * FROM ACTM a WHERE a.VFENDISC='Y'"

#pragma mark - 查询附加项
#define SELECT_ADDTITION @"select * from attach"

#pragma mark - 根据菜品编码查询附加项
#define SELECT_ADDTITION_FOR_PCODE @"select * from foodfujia where pcode='%@'"

#pragma mark - 查询附加项
#define SELECT_KC_ADDTITION @"select * from FoodFuJia where length(PCODE)=0 OR pcode like '%PCODE%'"


#pragma mark - 查询菜品类别
#define ZC_SELECT_CLASS @"select * from class order by GRP"
#define KC_SELECT_CLASS @"select * from class order by GRP"

#pragma mark - 查询菜品单位
#define KC_SELECT_UNIT @"select * from measdoc"

#pragma mark - 查询套餐名称
#define ZC_SELECT_PACKAGE @"select * from PACKAGE"

#pragma mark - 查询全部的菜品
#define SELECT_ALLFOOD_FOR_CLASS @"select * from food where class='%@'"

#pragma mark - 查询全部的菜品的外带价格
#define SELECT_TOGO_FOOD_FOR_CLASS @"select *,PRICE2 as PRICE from food where class='%@'"

#pragma mark - 查询套餐主菜
#define SELECT_PACKDTL @"select b.*,a.picBig,a.picSmall,a.pap,a.ITCODE from food a left JOIN PACKDTL b WHERE b.packid='%@' and b.item=a.item"

#pragma mark - 查询套餐主菜
#define SELECT_PACKDTL @"select b.*,a.picBig,a.picSmall,a.pap,a.ITCODE from food a left JOIN PACKDTL b WHERE b.packid='%@' and b.item=a.item"

#pragma mark - 查询套餐可换购
#define SELECT_ITEMPKG @"select b.*,a.picBig,a.picSmall,a.pap,a.ITCODE from food a left JOIN ITEMPKG b WHERE b.packid='%@' and b.ITEM='%@' and b.subitem=a.item"

#pragma mark - 查询套餐组
#define SELECT_PACKAGE_GROUP @"SELECT PNAME,PRICE1,PCODE1,PRODUCTTC_ORDER,MAXCNT,MINCNT FROM products_sub a WHERE defualtS = '0' and pcode='%@' GROUP BY PRODUCTTC_ORDER ORDER BY PRODUCTTC_ORDER  ASC"


#pragma mark - 查询计价方式为2的
#define SELECT_PRODUCTS_SUB_2 @"SELECT *,a.price as PRICE FROM food a left JOIN products_sub b on a.itcode=b.pcode1 WHERE b.pcode='%@' and PRODUCTTC_ORDER='%@' ORDER BY defualtS ASC"

#pragma mark - 查询套餐明细
#define SELECT_PRODUCTS_SUB @"SELECT *,b.price1 as PRICE FROM food a left JOIN products_sub b on a.itcode=b.pcode1 WHERE b.pcode='%@' and PRODUCTTC_ORDER='%@' ORDER BY defualtS ASC"

#endif
