//
//  MHCityManger.m
//  MHWeather
//
//  Created by wmh—future on 16/6/28.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import "MHCityManger.h"
#import "MHSQLiteTool.h"
#import "MHCityModel.h"
#import "MHSelectCity.h"
#import "MJExtension.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
@interface MHCityManger ()<UITableViewDelegate,UITableViewDataSource>
@property (strong ,nonatomic) NSMutableArray *cityArray;
@property (strong ,nonatomic) UITableView *tableView;
@end

@implementation MHCityManger

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cityMangerBcg"]];

    backgroundView.frame = [UIScreen mainScreen].bounds;
    
    [self.view addSubview:backgroundView];
    [self cityArrayWithSQl];
    [self addTableView];
    //设置查询城市观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:@"addNewCity" object:nil];

}
-(void)reloadTableView
{
    [self cityArrayWithSQl];
    [self.tableView reloadData];
    //刷新主界面的数据数组
//    RegistreCompletionNotification
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RegistreCompletionNotification" object:nil userInfo:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)addTableView
{
    
    CGRect tableViewFrame = CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT);
    _tableView = [[UITableView alloc] initWithFrame:tableViewFrame];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.backgroundView.alpha = 0.5;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}

- (void)cityArrayWithSQl
{
    [self.cityArray removeAllObjects];
    self.cityArray = [MHSQLiteTool searchCityArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cityArray.count + 1;
}

- (void)selectCity
{
    MHSelectCity *view = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectCity"];
    [self presentViewController:view animated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cityManger";
    static NSString *ID2 = @"addCity";
    
    
    if (indexPath.row == _cityArray.count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        UIButton *addCity = [[UIButton alloc] init];
        addCity.frame = CGRectMake(SCREEN_WIDTH - 60, 30, 30, 30);
        [addCity setImage:[UIImage imageNamed:@"数值加-1"] forState:UIControlStateNormal];
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView.alpha = 0.5;
        [addCity addTarget:self action:@selector(selectCity) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:addCity];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"添加城市";
        [cell addSubview:[self addOneView]];
        
        return cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID2];
        MHCityModel *cityModel = _cityArray[indexPath.row];
        if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID2];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor blackColor];
            cell.textLabel.font = [UIFont systemFontOfSize:30];
        cell.textLabel.text = cityModel.name_cn;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addSubview:[self addOneView]];
        }
        return cell;
        }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _cityArray.count) {
        return;
    }else
    {
        MHCityModel *city = _cityArray[indexPath.row];
        NSDictionary *dict = [city mj_keyValues];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cityIndex" object:nil userInfo:dict];
        //移除模态视图
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //数据库操作
        MHCityModel *model = _cityArray[indexPath.row];
        [MHSQLiteTool deleteCityWithModel:model];
         [self.cityArray removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        [self cityArrayWithSQl];
        [self cityArrayWithSQl];
        [self.tableView reloadData];
        
    }
}
- (UIView *)addOneView
{
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}
@end
