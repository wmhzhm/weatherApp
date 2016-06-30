//
//  MHIndexView.m
//  MHWeather
//
//  Created by wmh—future on 16/6/15.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import "MHIndexView.h"

@implementation MHIndexView
//- (instancetype)initWithCoder:(NSCoder *)aDecoder{
//    if (self = [super initWithCoder:aDecoder]) {
//        [self setup];
//    }
//    return self;
//}
//- (void)setup{
//    [[NSBundle mainBundle] loadNibNamed:@"MHIndexView" owner:self options:nil];
//    [self addSubview:self.view];
//    self.view.frame = self.bounds;
//}
- (void)loadWithModel:(MHIndexModel *)model
{
    //图标
    self.indexImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@icon",model.name]];
    //名字
    self.indexName.text = model.name;
    //指标程度
    self.index.text = model.index;
}
- (void)setIndexModel:(MHIndexModel *)indexModel
{
    //图标
    self.indexImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",indexModel.name]];
    //名字
    self.indexName.text = indexModel.name;
    //指标程度
    self.index.text = indexModel.index;
}
@end
