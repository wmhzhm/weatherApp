//
//  MHSelectCity.h
//  MHWeather
//
//  Created by wmh—future on 16/6/10.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHCityModel.h"

@interface MHSelectCity : UIViewController

+ (MHCityModel *)cityModelWithCityName:(NSString *)city;

+ (MHCityModel *)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg AtCity:(NSString *)city;
@end
