//
//  MHSQLiteTool.h
//  音乐播放器_1.0
//
//  Created by wmh—future on 16/3/21.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHCityModel.h"
#import <sqlite3.h>


@interface MHSQLiteTool : NSObject


+ (void)createTable:(const char *)sql named:(NSString *)tableName;
+ (void)addCityWithCityModel:(MHCityModel *)model;
+ (NSArray *)searchCityArray;
@end
