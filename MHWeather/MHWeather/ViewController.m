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


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *searchCityBtn;//搜索城市按钮
@property (weak, nonatomic) IBOutlet UILabel *currentCityLabel;//当前城市Label
@property (weak, nonatomic) IBOutlet UILabel *currentTemp;//当前温度

@property (copy ,nonatomic) NSString *currentCityName;//当前城市名
@property (strong ,nonatomic) MHCityModel *cityModel;//城市模型
@property (strong ,nonatomic) MHCurrentWeatherModel *currentWeatherModel;//当前天气模型
@property (strong ,nonatomic) <#type#> *<#name#>;
@property (strong ,nonatomic) NSArray *indexArray;//指标模型数组
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerCompletion:) name:@"RegistreCompletionNotification" object:nil];
    
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
//根据城市模型加载界面数据
- (void)getDataWithCity:(MHCityModel *)model{
    NSString *httpUrl = @"http://apis.baidu.com/apistore/weatherservice/recentweathers";
    NSString *httpArg = [NSString stringWithFormat:@"cityname=%@&cityid=%ld",[model.name_cn stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]],model.area_id];
    [self request: httpUrl withHttpArg: httpArg];
}

- (void)loadViewWithcurrentWeatherModel
{
    self.currentCityLabel.text = self.currentCityName;
    self.currentTemp.text = [NSString stringWithFormat:@"%@",self.currentWeatherModel.curTemp];
    NSLog(@"%@",self.currentTemp.text);
}


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
                                   
                                   
                                   
                                   //回到主线程
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       
                                       [self loadViewWithcurrentWeatherModel];
                                   });

                               }
                           }];
}


@end
