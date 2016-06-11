//
//  MHSelectCity.m
//  MHWeather
//
//  Created by wmh—future on 16/6/10.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import "MHSelectCity.h"
#import "MHCityModel.h"

@interface MHSelectCity()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *searchCityTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)clickAddBtn;
@property (strong ,nonatomic) NSArray *list;//原始数据
@property (strong ,nonatomic) NSArray *province;//省份数组

@end
NSInteger row = -1;
@implementation MHSelectCity

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)sendCity:(NSString *)city
{
    NSString *httpUrl = @"http://apis.baidu.com/apistore/weatherservice/citylist";
    
    NSString *httpArg = [NSString stringWithFormat:@"cityname=%@",[city stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [self request: httpUrl withHttpArg: httpArg];
    self.tableView.backgroundColor = [UIColor clearColor];
}

//发起城市数据请求
-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg  {
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"62167ba3aea12d9b14b5e4d56c1402bc" forHTTPHeaderField: @"apikey"];
    NSLog(@"Request : %@",request);
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                               } else {

                                   NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];//反序列化jason数据
                                   self.list = [dict objectForKey:@"retData"];
                                   NSArray *cityArray;
                                   NSMutableArray *mCityArray = [NSMutableArray array];
                                   for (NSDictionary *dictionary in self.list) {
                                       MHCityModel *model = [[MHCityModel alloc] initWithDict:dictionary];
                                       [mCityArray addObject:model];
                                   }
                                   cityArray = [mCityArray copy];
                                   self.province = cityArray;
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                   [self.tableView reloadData];
                                       row = -1;
                                   });
                               }
                           }];
}


- (IBAction)clickedHomeBtn {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"放弃定义城市并返回");
    }];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

//添加城市按钮
- (IBAction)clickAddBtn {
    
    [self dismissViewControllerAnimated:YES completion:^{
    if (row == -1) {
        return;
    }else{
        NSDictionary *dict = self.list[row];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RegistreCompletionNotification" object:nil userInfo:dict];
    }
    }];
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *city = self.searchCityTextField.text;
    NSLog(@"当前字段：%@",city);
    [self sendCity:city];
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *city = self.searchCityTextField.text;
    NSLog(@"当前字段：%@",city);
    [self sendCity:city];
    return YES;
}

#pragma mark - UITableViewDataSources
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.province.count;
}

#pragma mark - UITableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"city";
    MHCityModel *model = self.province[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:188/255  green:32/255 blue:3/255 alpha:0.11];

    }
//    cell.textLabel.text = [NSString stringWithFormat:@"%@,%@,%@",model.province_cn,model.district_cn,model.name_cn];
     cell.textLabel.text = [NSString stringWithFormat:@"%@,(%@,%@)",model.name_cn,model.province_cn,model.district_cn];
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    row = indexPath.row;
}

@end
