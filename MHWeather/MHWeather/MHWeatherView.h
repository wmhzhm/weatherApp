//
//  MHWeatherView.h
//  MHWeather
//
//  Created by wmh—future on 16/6/26.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define FONT_OF_CITY ([UIFont systemFontOfSize:30])
#define FONT_OF_TYPE ([UIFont systemFontOfSize:15])
#define FONT_OF_TEMP ([UIFont systemFontOfSize:70])
@interface MHWeatherView : UIViewController

@property (strong ,nonatomic) NSString *cityName;

@end
