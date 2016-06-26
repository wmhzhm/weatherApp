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


#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define FONT_OF_CITY ([UIFont systemFontOfSize:30])
#define FONT_OF_TYPE ([UIFont systemFontOfSize:10])
#define FONT_OF_TEMP ([UIFont systemFontOfSize:70])

@interface MHWeatherView ()<UITableViewDataSource,UITableViewDelegate>
@property (strong ,nonatomic) UITableView *weatherTableView;
@property (strong ,nonatomic) UILabel *currentCityLabel;
@property (strong ,nonatomic) UILabel *currentWeatherTypeLabel;
@property (strong ,nonatomic) UILabel *currentTempLabel;
//@property (strong ,nonatomic) UILabel *tempScope;

@property (strong ,nonatomic) NSArray *futuerWeatherData;//未来天气数据
@property (strong ,nonatomic) NSArray *futureWeatherArray;
@property (copy ,nonatomic) NSString *currentCityName;//当前城市名
@property (strong ,nonatomic) MHCityModel *cityModel;//城市模型
@property (strong ,nonatomic) MHCurrentWeatherModel *currentWeatherModel;//当前天气模型
@property (strong ,nonatomic) NSArray *indexArray;//指标模型数组
@property (strong ,nonatomic) NSString *cityName;
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
    [self.weatherTableView reloadData];
}

- (void)setCityName:(NSString *)cityName
{
    _cityName = cityName;
    //以加载名字的方式开始加载整个界面的数据
    [MHSelectCity cityModelWithCityName:cityName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addTableView
{
    //add TableView
    UITableView *weatherView = [[UITableView alloc] init];
    self.weatherTableView = weatherView;
    weatherView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    weatherView.backgroundColor = [UIColor clearColor];
    weatherView.delegate = self;
    weatherView.dataSource = self;
    
    
    //add TableHeadView
    CGRect headFrame = [UIScreen mainScreen].bounds;
    UIView *headView = [[UIView alloc] initWithFrame:headFrame];
    headView.backgroundColor = [UIColor clearColor];
    weatherView.tableHeaderView = headView;
    
    //add CurrentCityLabel
    CGRect currentCityFrame = CGRectMake(headView.frame.size.width / 2 - 30, 20, 60, 30);
    UILabel *currentCityLabel = [[UILabel alloc] initWithFrame:currentCityFrame];
    self.currentCityLabel = currentCityLabel;
    currentCityLabel.textColor = [UIColor whiteColor];
    currentCityLabel.textAlignment = NSTextAlignmentCenter;//文字居中
    currentCityLabel.font = FONT_OF_CITY;
    [headView addSubview:currentCityLabel];
    
    //add CurrentWeaterType
    CGRect currentWeatherTypeFrame = CGRectMake(headView.frame.size.width / 2 - 30, currentCityLabel.frame.origin.y + 5, 60, 40);
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
    
    [self.view addSubview:weatherView];
    
}

//根据城市模型发起天气数据请求
- (void)getDataWithCity:(MHCityModel *)model{
    NSString *httpUrl = @"http://apis.baidu.com/apistore/weatherservice/recentweathers";
    NSString *httpArg = [NSString stringWithFormat:@"cityname=%@&cityid=%ld",[model.name_cn stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]],model.area_id];
    [self request: httpUrl withHttpArg: httpArg];
}

//获取数据
-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg  {
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"62167ba3aea12d9b14b5e4d56c1402bc" forHTTPHeaderField: @"apikey"];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                               } else {
                                   //反序列化jason数据
                                   NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
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
                                   
                                   //回到主线程
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [self loadViewWithcurrentWeatherModel];
                                   });
                                   
                               }
                           }];
}

//根据当前天气加载数据
- (void)loadViewWithcurrentWeatherModel
{
//    //设置当前天气数据
    [self setCurrentWeatherData];
//    //未来天气数据
//    [self setFutureWeatherData];
//    //当天生活指数
//    [self setTodayIndexData];
}

- (void)setCurrentWeatherData
{

    //设置当前温度数据
    self.currentTempLabel.text = [NSString stringWithFormat:@"%@",self.currentWeatherModel.curTemp];
    //设置今日天气图标
//    self.currentTypeImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.currentWeatherModel.type]];
//    //天气类型
    self.currentWeatherTypeLabel.text = self.currentWeatherModel.type;
    //最高最低气温
//    self.tempScope.text = [NSString stringWithFormat:@"%@ ~ %@",self.currentWeatherModel.lowtemp,self.currentWeatherModel.hightemp];

}
#pragma mark - tableViewDelegate AND datasources

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.futureWeatherArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MHFutuerWeather *cell = [MHFutuerWeather futureWeatherCellWithTableView:tableView];
    MHFutuerWeatherModel *model = self.futureWeatherArray[indexPath.row];
    cell.futureWeather = model;
    return cell;
}

@end
