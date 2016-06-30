//
//  MHHeaderView.h
//  MHWeather
//
//  Created by wmh—future on 16/6/27.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHCurrentWeatherModel.h"
#import "MHIndexView.h"

@interface MHHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (weak, nonatomic) IBOutlet UILabel *typeName;
@property (weak, nonatomic) IBOutlet UILabel *currentTemp;
@property (weak, nonatomic) IBOutlet UIView *indexView;
@property (strong ,nonatomic) MHIndexView *one;
@property (strong ,nonatomic) MHIndexView *two;
@property (strong ,nonatomic) MHIndexView *three;
@property (strong ,nonatomic) MHIndexView *four;

@property (strong ,nonatomic) NSMutableArray *indexArray;
@property (strong ,nonatomic)  MHCurrentWeatherModel *currentWeatherModel;
+(instancetype)headView;
@end
