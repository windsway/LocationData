//
//  baseModel.h
//  locationSave
//
//  Created by wm on 2020/1/14.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface baseModel : NSObject
@property (nonatomic, assign) NSUInteger myid;
- (NSArray *)allPropertyNames;
@end

NS_ASSUME_NONNULL_END
