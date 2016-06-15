//
//  MHFutuerWeather.m
//  MHWeather
//
//  Created by wmh—future on 16/6/12.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import "MHFutuerWeather.h"


@implementation MHFutuerWeather

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)loadWithModel:(MHFutuerWeatherModel *)model
{
    
    //日期
    self.date.text = model.date;
    //星期
    self.week.text = model.week;
    //最高最低气温
     self.temp.text = [NSString stringWithFormat:@"%@ ~ %@",model.lowtemp,model.hightemp];
    //天气图标
    self.typeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",model.type]];
    //天气类型
     self.typeLabel.text = model.type;
}
@end
