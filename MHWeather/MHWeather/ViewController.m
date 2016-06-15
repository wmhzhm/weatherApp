//
//  ViewController.m
//  MHWeather
//
//  Created by wmh—future on 16/6/10.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import "ViewController.h"
#import "MHCityModel.h"
#import "MHCurrentWeatherModel.h"
#import "MHFutuerWeatherModel.h"
#import "MHFutuerWeather.h"

@class MHFutuerWeather;
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *searchCityBtn;//搜索城市按钮
@property (weak, nonatomic) IBOutlet UILabel *currentCityLabel;//当前城市Label
@property (weak, nonatomic) IBOutlet UIView *futureWeatherView;//未来天气视图
@property (weak, nonatomic) IBOutlet UILabel *currentTemp;//当前温度
@property (weak, nonatomic) IBOutlet UIImageView *currentTypeImg;//当前类型图片
@property (weak, nonatomic) IBOutlet UILabel *currentTypeLabel;//当前天气类型
@property (weak, nonatomic) IBOutlet UILabel *tempScope;//温度范围


@property (strong ,nonatomic) NSArray *futuerWeatherData;//未来天气数据
@property (strong ,nonatomic) NSArray *futureWeatherArray;
@property (copy ,nonatomic) NSString *currentCityName;//当前城市名
@property (strong ,nonatomic) MHCityModel *cityModel;//城市模型
@property (strong ,nonatomic) MHCurrentWeatherModel *currentWeatherModel;//当前天气模型
@property (strong ,nonatomic) NSArray *indexArray;//指标模型数组

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //设置查询城市观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerCompletion:) name:@"RegistreCompletionNotification" object:nil];
    
    //创建未来天气View内部视图
    [self initSmallView];
}
//加载未来天气视图
- (void)initSmallView
{
    CGFloat appX = 0;
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGFloat appW = rect.size.width;
     CGFloat appH = rect.size.height * 0.3 / 4;
    for (int n = 0; n < 4; n++) {
//        NSLog(@"外观宽度：%f,%f",appW,appWw);
        CGFloat appY = n * appH;
        NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"MHFutuerWeather" owner:nil options:nil];
        UIView *futureWeatherView = [objs lastObject];
        [self.futureWeatherView addSubview:futureWeatherView];
        futureWeatherView.frame = CGRectMake(appX, appY, appW, appH);
        
        //日期
        UILabel *dateLabel = futureWeatherView.subviews[0];
        dateLabel.text = @"--";
        //星期
        UILabel *weekLabel = futureWeatherView.subviews[1];
        weekLabel.text = @"--";
        //最高最低气温
        UILabel *tempLabel = futureWeatherView.subviews[2];
        tempLabel.text = @"-- ~ --";
        //天气图标
        //天气类型
        UILabel *typeLabel = futureWeatherView.subviews[4];
        typeLabel.text = @"--";
        //背景图片
        UIImageView *bagImage = futureWeatherView.subviews[5];
        bagImage.image = [UIImage imageNamed:@"cell背景"];
        bagImage.alpha = 0.5;
    }

}

//-(UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}

//收到回调的城市模型
- (void)registerCompletion:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    
    self.cityModel = [[MHCityModel alloc] initWithDict:dict];
    [self getDataWithCity:self.cityModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)getDataWithCity:(MHCityModel *)model{
    NSString *httpUrl = @"http://apis.baidu.com/apistore/weatherservice/recentweathers";
    NSString *httpArg = [NSString stringWithFormat:@"cityname=%@&cityid=%ld",[model.name_cn stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]],model.area_id];
    [self request: httpUrl withHttpArg: httpArg];
}
//根据当前天气加载数据
- (void)loadViewWithcurrentWeatherModel
{
    //设置当前天气数据
    [self setCurrentWeatherData];
    //未来天气数据
    [self setFutureWeatherData];
}



//设置当前天气数据
- (void)setCurrentWeatherData
{
    //设置城市数据
    self.currentCityLabel.text = self.currentCityName;
    //设置当前温度数据
    self.currentTemp.text = [NSString stringWithFormat:@"%@",self.currentWeatherModel.curTemp];
    //设置今日天气图标
    self.currentTypeImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.currentWeatherModel.type]];
    //天气类型
    self.currentTypeLabel.text = self.currentWeatherModel.type;
    //最高最低气温
    self.tempScope.text = [NSString stringWithFormat:@"%@ ~ %@",self.currentWeatherModel.lowtemp,self.currentWeatherModel.hightemp];
    
    
}


//设置未来天气数据
- (void)setFutureWeatherData
{
    
    int i = 0;
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"MHFutuerWeather" owner:nil options:nil];
    MHFutuerWeather *futureWeatherView = [objs lastObject];
    for (futureWeatherView in [self.futureWeatherView subviews]) {
        MHFutuerWeatherModel *model = self.futureWeatherArray[i];
        i++;
        //日期
        futureWeatherView.date.text = model.date;
        //星期
        futureWeatherView.week.text = model.week;
        //最高最低气温
        futureWeatherView.temp.text = [NSString stringWithFormat:@"%@ ~ %@",model.lowtemp,model.hightemp];
        //天气图标
        futureWeatherView.typeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",model.type]];
        //天气类型
        futureWeatherView.typeLabel.text = model.type;
    }

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


@end
