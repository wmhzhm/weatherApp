//
//  MHHeaderView.h
//  MHWeather
//
//  Created by wmh—future on 16/6/27.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHCurrentWeatherModel.h"

@interface MHHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (weak, nonatomic) IBOutlet UILabel *typeName;
@property (weak, nonatomic) IBOutlet UILabel *currentTemp;
@property (strong ,nonatomic)  MHCurrentWeatherModel *currentWeatherModel;
+(instancetype)headView;
@end
