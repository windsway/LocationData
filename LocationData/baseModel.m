//
//  baseModel.m
//  locationSave
//
//  Created by wm on 2020/1/14.
//  Copyright © 2020 mac. All rights reserved.
//

#import "baseModel.h"
#import <objc/runtime.h>
@implementation baseModel
- (NSArray *) allPropertyNames{
    
    ///存储所有的属性名称
    NSMutableArray *allNames = [[NSMutableArray alloc] init];
    unsigned int supcount = 0;
    objc_property_t *superProtys = class_copyPropertyList([[self class] superclass], &supcount);
    //把属性放到数组中
     for (int i = 0; i < supcount; i ++) {
         ///取出第一个属性
         objc_property_t supproperty = superProtys[i];
         
         const char * suppropertyName = property_getName(supproperty);
         
         [allNames addObject:[NSString stringWithUTF8String:suppropertyName]];
     }
    
    ///存储属性的个数
    unsigned int propertyCount = 0;
    
    ///通过运行时获取当前类的属性
    objc_property_t *propertys = class_copyPropertyList([self class], &propertyCount);
    
    //把属性放到数组中
    for (int i = 0; i < propertyCount; i ++) {
        ///取出第一个属性
        objc_property_t property = propertys[i];
        
        const char * propertyName = property_getName(property);
        
        [allNames addObject:[NSString stringWithUTF8String:propertyName]];
    }
    
    ///释放
    free(propertys);
    
    return allNames;
}
@end
