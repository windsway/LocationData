//
//  DataBaseManager.m
//  locationSave
//
//  Created by mac on 2020/1/15.
//  Copyright © 2020 mac. All rights reserved.
//

#import "DataBaseManager.h"
#import "YYModel.h"
#import "extensionDB.h"
@implementation DataBaseManager

/**
 根据表名初始化数据库
 */
+ (void)initdatabaseWithTableName:(NSArray *)array
{
    for (NSString *tableName in array) {
        [DataBaseManager createtable:tableName];
    }
}
/**
 创建表
 */
+(void)createtable:(NSString *)tableName{
    //1.判断表是否存在
    if (![extensionDB isExistTable:tableName]) {
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE %@ (id integer AUTO_INCREMENT PRIMARY KEY)",tableName];
        [[extensionDB sharedextensionDB] executeNonQuery:sql];
    }
    
    //2.存储对象的时候
    Class memberClass = NSClassFromString(tableName);
    baseModel *model = [memberClass yy_modelWithDictionary:@{}];
    NSArray *Propertys = [model allPropertyNames];
    NSArray *Columns = [extensionDB GetAllColumnStrInTable:tableName];
    //如果 模型属性有，表字段中没有，那么表中加上字段
    for (NSString *Propertystr in Propertys) {
        //
        if (![Columns containsObject:Propertystr]) {
            [extensionDB AddColumn:Propertystr InTable:tableName IsText:YES];
        }
    }
    //如果 模型属性没有，表字段中有，那么表中删除字段
    NSArray *NewColumns = [extensionDB GetAllColumnStrInTable:tableName];
    for (NSString *columnstr in NewColumns) {
        //
        if (![Propertys containsObject:columnstr]) {
            [extensionDB RemoveColumn:columnstr InTable:tableName];
        }
    }
    
}
/** replace小课字典 */
+(void)replaceSection:(baseModel *)model{
    if (!model) {return;}
    
    //INSERT INTO Section VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')
    NSString *sql2 = @"";
    NSString *sql1 = @"";
    NSString *sql3 = @"";
    NSMutableDictionary *columValueDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSArray *NewColumns2 = [extensionDB GetAllColumnStrInTable:NSStringFromClass([model class])];
    for (NSString *columnstr in NewColumns2) {
        
        sql1 = [sql1 stringByAppendingString:[NSString stringWithFormat:@"%@,",columnstr]];
        
        //判断value是字符串类型
        if ([[model valueForKeyPath:columnstr] isKindOfClass:[NSString class]]) {
            sql2 = [sql2 stringByAppendingString:[NSString stringWithFormat:@"'%@',",[model valueForKeyPath:columnstr]]];
        }else{
            sql2 = [sql2 stringByAppendingString:[NSString stringWithFormat:@"%@,",[model valueForKeyPath:columnstr]]];
        }
        if (![model valueForKeyPath:columnstr]) {
            NSString *tmpstr = @"";
            [columValueDic setValue:tmpstr forKey:columnstr];
        }
        else
        {
            [columValueDic setValue:[model valueForKeyPath:columnstr] forKey:columnstr];
        }
        sql3 = [sql3 stringByAppendingString:[NSString stringWithFormat:@":%@,",columnstr]];
    }
    //3.处理最后一个,号
    if (sql1.length > 1) {
        sql1 = [sql1 substringToIndex:sql1.length-1];
    }
    if (sql2.length > 1) {
        sql2 = [sql2 substringToIndex:sql2.length-1];
    }
    if (sql3.length > 1) {
        sql3 = [sql3 substringToIndex:sql3.length-1];
    }
    [[extensionDB sharedextensionDB] executeNonQuery:[NSString stringWithFormat:@"REPLACE INTO %@(%@) VALUES(%@)",NSStringFromClass([model class]),sql1,sql3] withDic:columValueDic];
}

/** 删除小课字典 */
+(void)removeSection:(baseModel *)model{
    if (!model) {return;}
    NSString *sql=[NSString stringWithFormat:@"DELETE FROM %@ WHERE id='%ld'",NSStringFromClass([model class]),(long)model.id];
    [[extensionDB sharedextensionDB] executeNonQuery:sql];
}
/** 删除所有小课信息 */
+(void)removeAllSection:(baseModel *)model{
    NSString *sql=[NSString stringWithFormat:@"DELETE FROM %@",NSStringFromClass([model class])];
    [[extensionDB sharedextensionDB] executeNonQuery:sql];
}
/** 查询所有小课信息 */
+(NSArray *)getAllSection:(baseModel *)model{
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM %@",NSStringFromClass([model class])];
    NSArray *rows= [[extensionDB sharedextensionDB] executeQuery:sql];
    NSMutableArray *NewArr = [NSMutableArray new];
    Class NowClass = [model class];
    for (NSDictionary *dic in rows) {
        baseModel *model = [NowClass yy_modelWithDictionary:dic];
        if (model) {
            [NewArr addObject:model];
        }
        
    }
    return NewArr;
}
/** 根据Id查询小课字典 */
+(baseModel *)getSectionById:(NSInteger)Id withtableModel:(baseModel *)model{
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE id='%ld'",NSStringFromClass([model class]), (long)Id];
    NSArray *rows= [[extensionDB sharedextensionDB] executeQuery:sql];
    return [[model class] yy_modelWithDictionary:rows.firstObject];
}
+(baseModel *)getSectionByProperty:(NSString *)name withCurrentModel:(baseModel *)model
{
    NSString *sql;
    if ([[model valueForKey:name] isKindOfClass:[NSString class]]) {
        sql=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@='%@'",NSStringFromClass([model class]),name,[model valueForKey:name]];
    }
    else
    {
        sql=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@='%d'",NSStringFromClass([model class]),name,[[model valueForKey:name] intValue]];
    }
    NSArray *rows= [[extensionDB sharedextensionDB] executeQuery:sql];
    return [[model class] yy_modelWithDictionary:rows.firstObject];
}

@end
