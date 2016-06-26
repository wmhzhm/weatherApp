//
//  MHFutuerWeather.h
//  MHWeather
//
//  Created by wmh—future on 16/6/12.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHFutuerWeatherModel.h"

@interface MHFutuerWeather : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *week;
@property (weak, nonatomic) IBOutlet UILabel *temp;
@property (weak, nonatomic) IBOutlet UIImageView *typeImage;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong ,nonatomic) MHFutuerWeatherModel *futureWeather;

+ (instancetype)futureWeatherCellWithTableView:(UITableView *)tableView;
@end
