//
//  extensionDB.m
//  locationSave
//
//  Created by mac on 2020/1/15.
//  Copyright © 2020 mac. All rights reserved.
//

#import "extensionDB.h"
#import "FMDB.h"
#define dDatabaseName @"WmDatabase.db"
@interface extensionDB()
@property(nonatomic,strong) FMDatabaseQueue *database;
@end
@implementation extensionDB
DenglSingletonM(extensionDB)

#pragma mark 重写初始化方法
-(instancetype)init{
    extensionDB *manager;
    if((manager=[super init]))
    {
        [manager openDb:dDatabaseName];
    }
    return manager;
}

-(void)openDb:(NSString *)dbname{
    //取得数据库保存路径，通常保存沙盒Documents目录
    NSString *directory=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"%@",directory);
    NSString *filePath=[directory stringByAppendingPathComponent:dbname];
    //创建FMDatabaseQueue对象
    self.database=[FMDatabaseQueue databaseQueueWithPath:filePath];
}

-(BOOL)executeNonQuery:(NSString *)sql{
    __block BOOL isB = NO;
    //执行更新sql语句，用于插入、修改、删除
    [self.database inDatabase:^(FMDatabase *db) {
        isB = [db executeUpdate:sql];
    }];
    return isB;
}
-(BOOL)executeNonQuery:(NSString *)sql withDic:(NSDictionary *)argDic;
{
    __block BOOL isB = NO;
    //执行更新sql语句，用于插入、修改、删除
    [self.database inDatabase:^(FMDatabase *db) {
        isB = [db executeUpdate:sql withParameterDictionary:argDic];
    }];
    return isB;
}
-(NSArray *)executeQuery:(NSString *)sql{
    NSMutableArray *array=[NSMutableArray array];
    [self.database inDatabase:^(FMDatabase *db) {
        //执行查询sql语句
        FMResultSet *result= [db executeQuery:sql];
        while (result.next) {
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            for (int i=0; i<result.columnCount; ++i) {
                dic[[result columnNameForIndex:i]]=[result stringForColumnIndex:i];
            }
            [array addObject:dic];
        }
    }];
    return array;
}

-(NSArray *)getAllColumnStrInTable:(NSString *)table{
    NSMutableArray *array=[NSMutableArray array];
    [self.database inDatabase:^(FMDatabase *db) {
        //执行查询sql语句
        FMResultSet *result= [db executeQuery:[NSString stringWithFormat:@"PRAGMA table_info([%@])",table]];
        while (result.next) {
            
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            for (int i=0; i<result.columnCount; ++i) {
                dic[[result columnNameForIndex:i]]=[result stringForColumnIndex:i];
            }
            if (dic[@"name"]) {
                [array addObject: [NSString stringWithFormat:@"%@",dic[@"name"]]];
            }
            
        }
    }];
    return array;
    
}

#pragma mark -
/**
 判断表是否存在
 
 @param tablename 表名
 */
+(BOOL)isExistTable:(NSString *)tablename{
    //1.检测表是否存在
    NSString *sql1 = [NSString stringWithFormat:@"select * from sqlite_master where type = 'table' and name = '%@'", tablename];
    NSArray *arr = [[extensionDB sharedextensionDB] executeQuery:sql1];
    if (arr.count != 0) {//存在
        return YES;
    }
    return NO;
}


/**
 判断表中的列字段是否存在
 
 @param column 列字段
 @param tablename 表名
 @return 返回是否存在
 */
+(BOOL)isExistColumn:(NSString *)column InTable:(NSString*)tablename{
    //判断表字段
    NSString *sql = [NSString stringWithFormat:@"select * from sqlite_master where type = 'table' and name = '%@'", tablename];
    NSArray *arr = [[extensionDB sharedextensionDB] executeQuery:sql];
    NSDictionary *dic = arr.firstObject;
    NSString *str1 = [dic objectForKey:@"sql"];
    NSArray *StrArr = [str1 componentsSeparatedByString:@"("];
    NSString *str2 = [NSString stringWithFormat:@"%@",StrArr.lastObject];
    if ([str2 containsString:[NSString stringWithFormat:@"%@ ",column]]) {
        return YES;
    }
    return NO;
}
/**
 删除表的列字段
 
 @param column 列字段
 @param tablename 表名
 */
+(void)RemoveColumn:(NSString *)column InTable:(NSString*)tablename{
    NSString *columnArrStr = @"";
    //1.列字段数组
    NSArray *columnArr = [[extensionDB sharedextensionDB] getAllColumnStrInTable:tablename];
    if (columnArr.count == 0) {return;}
    //2.拼接sql语句，复制列字段的时候
    for (NSString *columnStr in columnArr) {
        if (![columnStr isEqualToString:column]) {
            columnArrStr = [columnArrStr stringByAppendingString:[NSString stringWithFormat:@"%@,",columnStr]];
        }
    }
    //3.处理最后一个,号
    if (columnArrStr.length > 1) {
        columnArrStr = [columnArrStr substringToIndex:columnArrStr.length-1];
    }
    
    //1.创建一个临时的temptable
    NSString *sql1 = [NSString stringWithFormat:@"create table tempTable as select %@ from %@",columnArrStr,tablename];
    //2.删除旧表
    NSString *sql2 = [NSString stringWithFormat:@"drop table if exists %@",tablename];
    //3.给新表改名字
    NSString *sql3 = [NSString stringWithFormat:@"alter table tempTable rename to %@",tablename];
    
    [[extensionDB sharedextensionDB] executeNonQuery:sql1];
    [[extensionDB sharedextensionDB] executeNonQuery:sql2];
    [[extensionDB sharedextensionDB] executeNonQuery:sql3];
    
}
/**
 给表加列字段
 
 @param column 列字段
 @param tablename 表名
  INTEGER
 */
+(void)AddColumn:(NSString *)column InTable:(NSString*)tablename IsText:(BOOL)isText{
    //添加表列字段
    NSString *addColumnSql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ INTEGER",tablename,column];
    if (isText) {
        addColumnSql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ text",tablename,column];
    }
    [[extensionDB sharedextensionDB] executeNonQuery:addColumnSql];
}

/**
 获得表中所有的列字段
 
 @param tablename 表名
 */
+(NSArray *)GetAllColumnStrInTable:(NSString*)tablename{
    NSArray *arr = [[extensionDB sharedextensionDB] getAllColumnStrInTable:tablename];
    return arr;
}
@end
