//
//  MHWeatherView.m
//  MHWeather
//
//  Created by wmh—future on 16/6/26.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import "MHWeatherView.h"
#import "MHCityModel.h"
#import "MHCurrentWeatherModel.h"
#import "MHFutuerWeatherModel.h"
#import "MHFutuerWeather.h"
#import "MHIndexModel.h"
#import "MHIndexView.h"
#import "MHSelectCity.h"




@interface MHWeatherView ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (strong ,nonatomic) UITableView *weatherTableView;
@property (strong ,nonatomic) UILabel *currentCityLabel;
@property (strong ,nonatomic) UILabel *currentWeatherTypeLabel;
@property (strong ,nonatomic) UILabel *currentTempLabel;

@property (strong ,nonatomic) NSArray *futuerWeatherData;//未来天气数据
@property (strong ,nonatomic) NSArray *futureWeatherArray;
@property (copy ,nonatomic) NSString *currentCityName;//当前城市名
@property (strong ,nonatomic) MHCityModel *cityModel;//城市模型
@property (strong ,nonatomic) MHCurrentWeatherModel *currentWeatherModel;//当前天气模型
@property (strong ,nonatomic) NSArray *indexArray;//指标模型数组

@end

@implementation MHWeatherView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addTableView];
}

- (void)setFutureWeatherArray:(NSArray *)futureWeatherArray
{
    _futureWeatherArray = futureWeatherArray;
    [self loadViewWithcurrentWeatherModel];
}
#pragma mark - 加载数据的起点
    //以加载名字的方式开始加载整个界面的数据
- (void)setCityName:(NSString *)cityName
{
    _cityName = cityName;

    NSString *httpUrl = @"http://apis.baidu.com/apistore/weatherservice/citylist";
        
    NSString *httpArg = [NSString stringWithFormat:@"cityname=%@",[cityName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    [MHSelectCity request:httpUrl withHttpArg:httpArg AtCity:cityName Return:^(MHCityModel *model){
        self.cityModel = model;
    }];
}
//以模型加载界面数据
- (void)setCityModel:(MHCityModel *)cityModel
{
    _cityModel = cityModel;
    
    [self getDataWithCity:_cityModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGRect bounds = self.view.bounds;
    
    self.weatherTableView.frame = bounds;
}
- (void)addTableView
{
    //add TableView
     CGRect viewFrame = [UIScreen mainScreen].bounds;
    self.weatherTableView = [[UITableView alloc] init];
//    self.weatherTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    self.weatherTableView.frame = viewFrame;
    self.weatherTableView.backgroundColor = [UIColor clearColor];
    self.weatherTableView.delegate = self;
    self.weatherTableView.dataSource = self;
    self.weatherTableView.separatorStyle = NO;
    self.weatherTableView.pagingEnabled = YES;
    
    //add TableHeadView
//    CGRect headFrame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT / 2);
    UIView *headView = [[UIView alloc] initWithFrame:viewFrame];
    headView.backgroundColor = [UIColor blueColor];
    self.weatherTableView.tableHeaderView = headView;
    
    
    //add CurrentCityLabel
    CGRect currentCityFrame = CGRectMake(0, 40, SCREEN_WIDTH, 30);
    UILabel *currentCityLabel = [[UILabel alloc] initWithFrame:currentCityFrame];
    self.currentCityLabel = currentCityLabel;
    currentCityLabel.textColor = [UIColor whiteColor];
    currentCityLabel.textAlignment = NSTextAlignmentCenter;//文字居中
    currentCityLabel.font = FONT_OF_CITY;
    [headView addSubview:currentCityLabel];
    
    //add CurrentWeaterType
    CGRect currentWeatherTypeFrame = CGRectMake(0, currentCityLabel.frame.origin.y + 35, SCREEN_WIDTH, 30);
    UILabel *currentWeatherTypeLabel = [[UILabel alloc] initWithFrame:currentWeatherTypeFrame];
    self.currentWeatherTypeLabel = currentWeatherTypeLabel;
    currentWeatherTypeLabel.textColor = [UIColor whiteColor];
    currentWeatherTypeLabel.textAlignment = NSTextAlignmentCenter;//文字居中
    currentWeatherTypeLabel.font = FONT_OF_TYPE;
    [headView addSubview:currentWeatherTypeLabel];
    
    //add currentTemp
    CGRect currentTempFrame = CGRectMake(0, currentWeatherTypeLabel.frame.origin.y + 5, SCREEN_WIDTH, 140);
    UILabel *currentTempLabel = [[UILabel alloc] initWithFrame:currentTempFrame];
    self.currentTempLabel = currentTempLabel;
    currentTempLabel.textColor = [UIColor whiteColor];
    currentTempLabel.textAlignment = NSTextAlignmentCenter;//文字居中
    currentTempLabel.font = FONT_OF_TEMP;
    [headView addSubview:currentTempLabel];
    
    //add backgroundImg
//    CGRect backgroundImageFrame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:backgroundImageFrame];
//    backgroundImage.image = [UIImage imageNamed:@"background1"];
//    [self.view addSubview:backgroundImage];
//    self.view.backgroundColor = [UIColor blackColor];

     [self.view addSubview:self.weatherTableView];
}

//根据城市模型发起天气数据请求
- (void)getDataWithCity:(MHCityModel *)model{
    NSString *httpUrl = @"http://apis.baidu.com/apistore/weatherservice/recentweathers";
    NSString *httpArg = [NSString stringWithFormat:@"cityname=%@&cityid=%ld",[model.name_cn stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]],model.area_id];

    [MHSelectCity request:httpUrl withHttpArg:httpArg Return:^(NSDictionary *dict){
        //获取当前城市
        self.currentCityName = [[dict objectForKey:@"retData"] objectForKey:@"city"];
        
        //获取当前天气模型
        self.currentWeatherModel = [[MHCurrentWeatherModel alloc] initWithDict:[[dict objectForKey:@"retData"] objectForKey:@"today"]];
        
        //获取指数模型数组
        NSMutableArray *mIndexArray = [NSMutableArray array];
        for (NSDictionary *dict in self.currentWeatherModel.index) {
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
        //获取未来天气模型
        self.futuerWeatherData = [[dict objectForKey:@"retData"] objectForKey:@"forecast"];
        
        NSMutableArray *mFutuerWeatherArray = [NSMutableArray array];
        for (NSDictionary *dictF in self.futuerWeatherData) {
            MHFutuerWeatherModel *futureWeatherModel = [[MHFutuerWeatherModel alloc] initWithDict:dictF];
            [mFutuerWeatherArray addObject:futureWeatherModel];
        }
        //获取未来天气模型数组
        self.futureWeatherArray = [mFutuerWeatherArray copy];
    }];
}

//根据当前天气加载数据
- (void)loadViewWithcurrentWeatherModel
{

//    //设置当前天气数据
    [self setCurrentWeatherData];

}

- (void)setCurrentWeatherData
{
    //设置当前城市
    self.currentCityLabel.text = self.cityModel.name_cn;
    //设置当前温度数据
    self.currentTempLabel.text = [NSString stringWithFormat:@"%@",self.currentWeatherModel.curTemp];
    //设置今日天气图标
  //天气类型
    self.currentWeatherTypeLabel.text = self.currentWeatherModel.type;
    //最高最低气温


}

#pragma mark - tableViewDelegate AND datasources

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.indexArray count] + 1;
    }
    return [self.futureWeatherArray count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    MHFutuerWeather *cell = [MHFutuerWeather futureWeatherCellWithTableView:tableView];
//    MHFutuerWeatherModel *model = self.futureWeatherArray[indexPath.row];
//    cell.futureWeather = model;
//    
//    return cell;
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self configureHeaderCell:cell title:@"Hourly Forecast"];
        }
        else {
            MHFutuerWeatherModel *weather = self.futureWeatherArray[indexPath.row - 1];
//            [self configureHourlyCell:cell weather:weather];
            [self configureHourlyCell:cell weather:weather];
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self configureHeaderCell:cell title:@"Daily Forecast"];
        }
        else {
            MHIndexModel *indexModel = self.indexArray[indexPath.row - 1];
            NSLog(@"daylicell");
        }
    }
    //    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;

}
- (void)configureHeaderCell:(UITableViewCell *)cell title:(NSString *)title {
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = @"";
    cell.imageView.image = nil;
}

- (void)configureHourlyCell:(UITableViewCell *)cell weather:(MHFutuerWeatherModel *)weather {
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    cell.textLabel.text = weather.date;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ ~ %@",weather.lowtemp,weather.hightemp];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",weather.type]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
}
@end
