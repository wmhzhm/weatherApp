//
//  MHSelectCity.h
//  MHWeather
//
//  Created by wmh—future on 16/6/10.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHCityModel.h"

typedef void (^ReturnModelBlock)(MHCityModel *model);
typedef void (^ReturnDictBlock)(NSDictionary *dict);
@interface MHSelectCity : UIViewController


+ (void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg AtCity:(NSString *)city Return:(ReturnModelBlock)returnModelBlock;
+(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg  Return:(ReturnDictBlock)returnDictBlock;
//+ (void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg AtCity:(NSString *)city getUrl;
+ (void)upDateCityModelWithCityName:(NSString *)city;
+ (void)updateCity:(NSString *)city request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg;
@end
