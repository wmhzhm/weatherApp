//
//  MHHeaderView.m
//  MHWeather
//
//  Created by wmh—future on 16/6/27.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import "MHHeaderView.h"

@implementation MHHeaderView

+(instancetype)headView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"MHHeaderView" owner:nil options:nil] lastObject];
}
- (void)setCurrentWeatherModel:(MHCurrentWeatherModel *)currentWeatherModel
{
//    @property (weak, nonatomic) IBOutlet UILabel *cityName;
//    @property (weak, nonatomic) IBOutlet UILabel *typeName;
//    @property (weak, nonatomic) IBOutlet UILabel *currentTemp;
    self.typeName.text = currentWeatherModel.type;
    self.currentTemp.text = currentWeatherModel.curTemp;
}

@end
