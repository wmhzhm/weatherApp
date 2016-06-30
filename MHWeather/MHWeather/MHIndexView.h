//
//  MHIndexView.h
//  MHWeather
//
//  Created by wmh—future on 16/6/15.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHIndexModel.h"

@interface MHIndexView : UIView
@property (nonatomic ,strong) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIImageView *indexImageView;
@property (weak, nonatomic) IBOutlet UILabel *indexName;
@property (weak, nonatomic) IBOutlet UILabel *index;
@property (strong ,nonatomic) MHIndexModel *indexModel;
- (void)loadWithModel:(MHIndexModel *)model;
@end
