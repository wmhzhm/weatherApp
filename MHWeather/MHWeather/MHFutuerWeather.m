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
- (void)setFutureWeather:(MHFutuerWeatherModel *)futureWeather
{
    //日期
    self.date.text = futureWeather.date;
    //星期
    self.week.text = futureWeather.week;
    //最高最低气温
    self.temp.text = [NSString stringWithFormat:@"%@ ~ %@",futureWeather.lowtemp,futureWeather.hightemp];
    //天气图标
    self.typeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",futureWeather.type]];
    //天气类型
    self.typeLabel.text = futureWeather.type;

}

+ (instancetype)futureWeatherCellWithTableView:(UITableView *)tableView
{
    static  NSString  *ID = @"futureWeatherCell";
    MHFutuerWeather  *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"MHFutuerWeather" owner:nil options:nil];
        cell = [nibs firstObject];
        cell.backgroundColor = [UIColor blackColor];
    }
    return cell;
}
@end

