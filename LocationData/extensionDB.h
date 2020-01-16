//
//  extensionDB.h
//  locationSave
//
//  Created by mac on 2020/1/15.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationDefine.h"
NS_ASSUME_NONNULL_BEGIN

@interface extensionDB : NSObject
DenglSingletonH(extensionDB)
/**
 *  打开数据库
 *
 *  @param dbname 数据库名字
 */
-(void)openDb:(NSString *)dbname;
/**
 *  执行无返回值的sql语句
 *
 */
-(BOOL)executeNonQuery:(NSString *)sql;
/**
 *  执行无返回值的sql语句 带数组参数
 *
 */
-(BOOL)executeNonQuery:(NSString *)sql withDic:(NSDictionary *)argDic;
/**
 *  执行有返回值的sql语句
 *
 */
-(NSArray *)executeQuery:(NSString *)sql;

/**
    获取表中的所有列名
 */
-(NSArray *)getAllColumnStrInTable:(NSString *)table;

#pragma mark -
/**
 判断表是否存在
 
 @param tablename 表名
 */
+(BOOL)isExistTable:(NSString *)tablename;


/**
 判断表中的列字段是否存在
 
 @param column 列字段
 @param tablename 表名
 @return 返回是否存在
 */
+(BOOL)isExistColumn:(NSString *)column InTable:(NSString*)tablename;
/**
 删除表的列字段
 
 @param column 列字段
 @param tablename 表名
 */
+(void)RemoveColumn:(NSString *)column InTable:(NSString*)tablename;

/**
 给表加列字段
 
 @param column 列字段
 @param tablename 表名
 INTEGER
 */
+(void)AddColumn:(NSString *)column InTable:(NSString*)tablename IsText:(BOOL)isText;

/**
 获得表中所有的列字段
 
 @param tablename 表名
 */
+(NSArray *)GetAllColumnStrInTable:(NSString*)tablename;
@end

NS_ASSUME_NONNULL_END
