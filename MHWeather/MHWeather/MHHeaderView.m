//
//  MHHeaderView.m
//  MHWeather
//
//  Created by wmh—future on 16/6/27.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import "MHHeaderView.h"
#import "MHIndexModel.h"
#import "MHIndexView.h"
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define INDEX_HEIGHT (([UIScreen mainScreen].bounds.size.height - 50) / 8)
@implementation MHHeaderView

+(instancetype)headView
{
    MHHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:@"MHHeaderView" owner:nil options:nil] lastObject];
    for (int i = 0; i < 4 ; i++) {
    MHIndexView *indexOne = [[[NSBundle mainBundle] loadNibNamed:@"MHIndexView" owner:nil options:nil] lastObject];
    indexOne.frame = CGRectMake(0, i * INDEX_HEIGHT, SCREEN_WIDTH , INDEX_HEIGHT);
        if (i == 3) {
            NSLog(@"%f",indexOne.frame.size.height);
        }
    [view.indexView addSubview:indexOne];
    }
    
    return view;
}


- (void)setCurrentWeatherModel:(MHCurrentWeatherModel *)currentWeatherModel
{
    self.typeName.text = currentWeatherModel.type;
    self.currentTemp.text = currentWeatherModel.curTemp;
    //获取指数模型数组
    NSMutableArray *mIndexArray = [NSMutableArray array];
    for (NSDictionary *dict in currentWeatherModel.index) {
        MHIndexModel *indexModel = [[MHIndexModel alloc] initWithDict:dict];
        [mIndexArray addObject:indexModel];
    }
    self.indexArray = [mIndexArray copy];
    //过滤指数
    [mIndexArray removeAllObjects];
    for (int i = 0; i < self.indexArray.count; i++) {
        MHIndexModel *model = self.indexArray[i];
        if (![model.code  isEqualToString:@"gm"] && ![model.code isEqualToString:@"ls"])
        {
            [mIndexArray addObject:model];
        }
    }
    self.indexArray = [mIndexArray copy];
    
    //加载生活指数
    self.one = _indexView.subviews[0];
    self.two = _indexView.subviews[1];
    self.three = _indexView.subviews[2];
    self.four = _indexView.subviews[3];
//    [_one loadWithModel:_indexArray[0]];
//    [_two loadWithModel:_indexArray[1]];
//    [_three loadWithModel:_indexArray[2]];
//    [_four loadWithModel:_indexArray[3]];
    _one.indexModel = _indexArray[0];
    _two.indexModel = _indexArray[1];
    _three.indexModel = _indexArray[2];
    _four.indexModel = _indexArray[3];
    
}



@end
