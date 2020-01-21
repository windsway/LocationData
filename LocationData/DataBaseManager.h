//
//  DataBaseManager.h
//  locationSave
//
//  Created by mac on 2020/1/15.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "baseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DataBaseManager : NSObject
+ (void)initdatabaseWithTableName:(NSArray *)array;
/** 添加对象 */
+(void)replaceSection:(baseModel *)model;

/** 删除对象 */
+(void)removeSection:(baseModel *)model;
/** 删除所有 */
+(void)removeAllSection:(baseModel *)model;
/** 查询所有 */
+(NSArray *)getAllSection:(baseModel *)model;
/** 根据Id查询 */
+(baseModel *)getSectionById:(NSInteger)Id withtableModel:(baseModel *)model;
/**根据字段获取对象*/
+(baseModel *)getSectionByProperty:(NSString *)name withCurrentModel:(baseModel *)model;
/**
 多条件单表查询
 */
+ (NSArray *)getSectionByRelevanceSignTable:(baseModel *)model withPropertys:(NSDictionary *)propetys;
/**
 关联多表查询
 @example info = @{@"tabe1":@{@"des":@"value"},@"table2":@{@"searchKey":@"property",@"searchValue":@"value",@"resultKey":@"resultValue"}}
 tabe1 结果集表
    value 目标参数
 table2 条件集
    searchkey 查询字段
    searchvalue 查询字段对应值
    reslutkey 结果字段
 */
+ (NSArray *)getSectionByRelevanceMoreTable:(NSDictionary *)info;
@end

NS_ASSUME_NONNULL_END
