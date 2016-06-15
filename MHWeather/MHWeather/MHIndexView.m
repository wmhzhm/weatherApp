//
//  MHIndexView.m
//  MHWeather
//
//  Created by wmh—future on 16/6/15.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import "MHIndexView.h"

@implementation MHIndexView
- (void)loadWithModel:(MHIndexModel *)model
{
    //图标
    self.indexImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@icon",model.name]];
    //名字
    self.indexName.text = model.name;
    //指标程度
    self.index.text = model.index;
}

@end
