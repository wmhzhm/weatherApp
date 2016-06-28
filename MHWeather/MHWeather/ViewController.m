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
#import "MHIndexModel.h"
#import "MHIndexView.h"
#import "MHWeatherView.h"
#import "MHSQLiteTool.h"
#import "MHSelectCity.h"
#import "MHHeaderView.h"
#import "MHCityManger.h"

#define ScrollTableWidth [UIScreen mainScreen].bounds.size.width
#define ScrollTableHeight [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong ,nonatomic) UIScrollView *scrollView;
@property (strong ,nonatomic) UIPageControl *pageControl;
@property (strong ,nonatomic) NSArray *cityArray;
@property (nonatomic,strong) NSDictionary *leftArr;
@property (nonatomic,strong) NSDictionary *midArr;
@property (nonatomic,strong) NSDictionary *rigthArr;
@property (nonatomic,assign) NSInteger currentIndex;//当前的序列
@property (strong ,nonatomic) NSMutableArray *mDataArray;//所有天气数据
@property (strong ,nonatomic) NSArray *dataArray;
@property (strong ,nonatomic) MHHeaderView *leftHeadView;
@property (strong ,nonatomic) MHHeaderView *midHeadView;
@property (strong ,nonatomic) MHHeaderView *rightHeadView;


@property (strong ,nonatomic) UITableView *leftTableView;
@property (strong ,nonatomic) UITableView *midTableView;
@property (strong ,nonatomic) UITableView *rightTableView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor clearColor];
    //add背景图
    UIImageView *background = [[UIImageView alloc] init];
    background.frame = [UIScreen mainScreen].bounds;
    background.image = [UIImage imageNamed:@"background1"];
    [self.view addSubview:background];
    //获取目前需要查询的城市信息
    self.cityArray = [MHSQLiteTool searchCityArray];
    //add scrollView
    CGRect scrollerViewFrame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.scrollView = [[UIScrollView alloc] initWithFrame:scrollerViewFrame];
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor clearColor];
//    self.scrollView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    //add PageControl
    CGRect pageControlFrame = CGRectMake(0, SCREEN_HEIGHT - 30, SCREEN_WIDTH, 30);
    self.pageControl = [[UIPageControl alloc] initWithFrame:pageControlFrame];
    self.pageControl.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_pageControl];
    
    [self loadWeatherView];
    
    
    //测试用btn
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30, 0, 30, 30)];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"search_city_btn"] forState:UIControlStateNormal];
    [self.pageControl addSubview:btn];
    
    _currentIndex = 0;
    _mDataArray = [NSMutableArray array];
    [self getCityArray];
    //设置查询城市观察者
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerCompletion) name:@"RegistreCompletionNotification" object:nil];
    //设置索引观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToIndex:) name:@"cityIndex" object:nil];
}

- (void)jumpToIndex:(NSNotification *)notification
{
    NSDictionary *dict = notification.userInfo;
    MHCityModel *city = [[MHCityModel alloc] initWithDict:dict];
    
    
    for (int i = 0; i < _cityArray.count; i++) {
        MHCityModel *toCity = _cityArray[i];
        if ([city.name_cn isEqualToString:toCity.name_cn]) {
            //跳转到此索引(i)
            _currentIndex = i;
            [self changeTableViewAndLoadData];
        }
    }
}


- (void)registerCompletion
{
    [self getCityArray];
}


-(void)click
{
    //弹出模态视图选择城市
//    MHSelectCity * selectCity = [[MHSelectCity alloc]init];
//    selectCity.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    MHCityManger *view = [self.storyboard instantiateViewControllerWithIdentifier:@"CityManger"];
//    [self presentViewController:selectCity animated:YES completion:nil];
    [self presentViewController:view animated:YES completion:nil];
}


//获取目前的城市
- (void)getCityArray{
    self.cityArray = [[NSArray alloc] init];
    self.cityArray = [MHSQLiteTool searchCityArray];
    //得到所有城市的数据
    [self.mDataArray removeAllObjects];
    for (int i = 0 ; i < _cityArray.count; i ++) {
        MHCityModel *city = _cityArray[i];
        [self getDataWithCity:city];
    }
    
}


- (void)getDataWithCity:(MHCityModel *)model{
    NSString *httpUrl = @"http://apis.baidu.com/apistore/weatherservice/recentweathers";
    NSString *httpArg = [NSString stringWithFormat:@"cityname=%@&cityid=%ld",[model.name_cn stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]],model.area_id];
    
    [MHSelectCity request:httpUrl withHttpArg:httpArg Return:^(NSDictionary *dict){

        [_mDataArray addObject:dict];
        _dataArray = _mDataArray;
        if ([_dataArray count] == [_cityArray count]) {
            //将_dataArray数组的顺序调整
            NSMutableArray *array = [NSMutableArray array];
            for (int index = 0; index < _cityArray.count; index++) {
                MHCityModel *model = _cityArray[index];
            for (int i = 0; i < [_dataArray count]; i++) {
                    NSString *cityName = [[_dataArray[i] objectForKey:@"retData"] objectForKey:@"city"];
                if ([cityName isEqualToString:model.name_cn]) {
                    [array addObject:_dataArray[i]];
                    }
                }
            }
            //排序完成重新赋值
            _dataArray = array;
            [self changeTableViewAndLoadData];
        }
    }];
}

//根据城市数组加载界面
- (void)loadWeatherView
{
    //创建TableView
    self.leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 30)];
    self.midTableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 30)];
    self.rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 30)];
    
    //创建TableHeaderView
    _leftHeadView = [MHHeaderView headView];
    _midHeadView = [MHHeaderView headView];
    _rightHeadView = [MHHeaderView headView];
    
    _leftHeadView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _midHeadView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _rightHeadView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

    
    [_leftTableView setTableHeaderView:_leftHeadView];
    [_midTableView setTableHeaderView:_midHeadView];
    [_rightTableView setTableHeaderView:_rightHeadView];
    
    
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.backgroundColor = [UIColor clearColor];
    _midTableView.delegate = self;
    _midTableView.dataSource = self;
    _midTableView.backgroundColor = [UIColor clearColor];
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
    _rightTableView.backgroundColor = [UIColor clearColor];
    
    [self.scrollView addSubview:self.leftTableView];
    [self.scrollView addSubview:self.midTableView];
    [self.scrollView addSubview:self.rightTableView];
    [_scrollView setContentSize:CGSizeMake(3 * SCREEN_WIDTH, SCREEN_HEIGHT)];
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
//确保索引可用
-(NSInteger)indexForEnable:(NSInteger)index{
    if (index < 0 || index == 0) {
        return _currentIndex=0;
    }else if (index > self.dataArray.count - 1 || index == self.dataArray.count - 1){
        return _currentIndex = self.dataArray.count-1;
    }else{
        return _currentIndex==index;
    }
}
- (void)changeTableViewAndLoadData{
    //index = 0 情况，只需要刷新左边tableView和中间tableView
    if (_currentIndex == 0) {
        _leftArr = self.dataArray[_currentIndex];
        _midArr = self.dataArray[_currentIndex +1];
        
        [_leftTableView reloadData];
        [_midTableView reloadData];
        _leftHeadView.currentWeatherModel = [self currentWeatherModelWithDict:_leftArr];
        _leftHeadView.cityName.text = [self currentCityWithDict:_leftArr];
        _midHeadView.currentWeatherModel = [self currentWeatherModelWithDict:_midArr];
        _midHeadView.cityName.text = [self currentCityWithDict:_midArr];
        
        self.scrollView.contentOffset = CGPointMake(0, 0);
        
        //index 是为最后的下标时，刷新右边tableView 和 中间 tableView
    }else if(_currentIndex == _dataArray.count - 1){
        _rigthArr = self.dataArray[_currentIndex];
        _midArr = self.dataArray[_currentIndex - 1];
        [_rightTableView reloadData];
        [_midTableView reloadData];
        
        _midHeadView.currentWeatherModel = [self currentWeatherModelWithDict:_midArr];
        _midHeadView.cityName.text = [self currentCityWithDict:_midArr];
        _rightHeadView.currentWeatherModel = [self currentWeatherModelWithDict:_rigthArr];
        _rightHeadView.cityName.text = [self currentCityWithDict:_rigthArr];
        
        self.scrollView.contentOffset = CGPointMake(ScrollTableWidth*2, 0);
        //除了上边两种情况，三个tableView 都要刷新，为了左右移动时都能够显示数据
    }else{
        _rigthArr = self.dataArray[_currentIndex+1];
        _midArr = self.dataArray[_currentIndex];
        _leftArr = self.dataArray[_currentIndex - 1];
        //刷新cell
        [_rightTableView reloadData];
        [_midTableView reloadData];
        [_leftTableView reloadData];
        //刷新头部视图
        _leftHeadView.currentWeatherModel = [self currentWeatherModelWithDict:_leftArr];
        _leftHeadView.cityName.text = [self currentCityWithDict:_leftArr];
        _midHeadView.currentWeatherModel = [self currentWeatherModelWithDict:_midArr];
        _midHeadView.cityName.text = [self currentCityWithDict:_midArr];
        _rightHeadView.currentWeatherModel = [self currentWeatherModelWithDict:_rigthArr];
        _rightHeadView.cityName.text = [self currentCityWithDict:_rigthArr];
        
        self.scrollView.contentOffset = CGPointMake(ScrollTableWidth, 0);
    }
}
- (NSString *)currentCityWithDict:(NSDictionary *)dict
{
    return  [[dict objectForKey:@"retData"] objectForKey:@"city"];
}

- (MHCurrentWeatherModel *)currentWeatherModelWithDict:(NSDictionary *)dict
{
    MHCurrentWeatherModel *currentWeatherModel = [[MHCurrentWeatherModel alloc] initWithDict:[[dict objectForKey:@"retData"] objectForKey:@"today"]];
    return currentWeatherModel;
}

- (NSArray *)indexModelWithCurrentWeatherModel:(MHCurrentWeatherModel *)currentWeatherModel
{
            //获取指数模型数组
        NSArray *indexArray;
            NSMutableArray *mIndexArray = [NSMutableArray array];
            for (NSDictionary *dict in currentWeatherModel.index) {
                MHIndexModel *indexModel = [[MHIndexModel alloc] initWithDict:dict];
                [mIndexArray addObject:indexModel];
            }
            indexArray = [mIndexArray copy];
            //过滤指数
            [mIndexArray removeAllObjects];
            for (int i = 0; i < indexArray.count; i++) {
                MHIndexModel *model = indexArray[i];
                if (![model.code  isEqualToString:@"gm"] && ![model.code isEqualToString:@"ls"])
                {
                    [mIndexArray addObject:model];
                }
            }
            indexArray = [mIndexArray copy];
    return indexArray;
}


- (NSArray *)futureWeatherArrayWithDict:(NSDictionary *)dict
{
        //获取未来天气模型
            NSArray *futuerWeatherData = [[dict objectForKey:@"retData"] objectForKey:@"forecast"];
            NSArray *futureWeatherArray;
            NSMutableArray *mFutuerWeatherArray = [NSMutableArray array];
            for (NSDictionary *dictF in futuerWeatherData) {
                MHFutuerWeatherModel *futureWeatherModel = [[MHFutuerWeatherModel alloc] initWithDict:dictF];
                [mFutuerWeatherArray addObject:futureWeatherModel];
            }
            //获取未来天气模型数组
           futureWeatherArray = [mFutuerWeatherArray copy];
    return futureWeatherArray;
}
//- (void)changeTableViewAndLoadData{
//    //index = 0 情况，只需要刷新左边tableView和中间tableView
//    if (_currentIndex == 0) {
//        _leftArr = self.tabArr[_currentIndex];
//        _midArr = self.tabArr[_currentIndex +1];
//        
//        [_leftTable reloadData];
//        [_midTable reloadData];
//        
//        self.scrollView.contentOffset = CGPointMake(0, 0);
//        
//        //index 是为最后的下标时，刷新右边tableView 和 中间 tableView
//    }else if(_currentIndex == _tabArr.count - 1){
//        _rigthArr = self.tabArr[_currentIndex];
//        _midArr = self.tabArr[_currentIndex - 1];
//        [_rightTable reloadData];
//        [_midTable reloadData];
//        
//        self.scrollView.contentOffset = CGPointMake(ScrollTableWidth*2, 0);
//        //除了上边两种情况，三个tableView 都要刷新，为了左右移动时都能够显示数据
//    }else{
//        _rigthArr = self.tabArr[_currentIndex+1];
//        _midArr = self.tabArr[_currentIndex];
//        _leftArr = self.tabArr[_currentIndex - 1];
//        
//        [_rightTable reloadData];
//        [_midTable reloadData];
//        [_leftTable reloadData];
//        
//        self.scrollView.contentOffset = CGPointMake(ScrollTableWidth, 0);
//    }
//}
#pragma mark - scrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView != self.scrollView) {
        return;
    }
    //tableView继承scrollView，如果没有上面的判断下拉tableView的时候默认scrollView.contentOffset.x == 0也就是认为向右滑动
    if (scrollView.contentOffset.x == 0) {//右滑（看上一张）
        _currentIndex--;
    }
    if (scrollView.contentOffset.x == ScrollTableWidth * 2){//左滑（看下一张）
        _currentIndex++;
    }
    //在最左边往左滑看下一张
    if (_currentIndex == 0 && scrollView.contentOffset.x == ScrollTableWidth){
        _currentIndex++;
    }
    //在最右边往右滑看上一张
    if(_currentIndex == self.dataArray.count-1 && scrollView.contentOffset.x == ScrollTableWidth){
        _currentIndex--;
    }
    if ([scrollView isEqual:self.scrollView]) {
        if (_currentIndex<0) {
            _currentIndex=0;
        }
        if (_currentIndex>self.dataArray.count-1) {
            _currentIndex=self.dataArray.count-1;
        }
//        _scroll.index = _currentIndex;
    }
    [self indexForEnable:_currentIndex];
    [self changeTableViewAndLoadData];

}



#pragma mark - tableView Delegate and Datasources

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return SCREEN_HEIGHT;
//}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *ID = @"cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
//        cell.backgroundColor = [UIColor clearColor];
//        cell.textLabel.textColor = [UIColor whiteColor];
//    }
    
        MHFutuerWeather *cell = [MHFutuerWeather futureWeatherCellWithTableView:tableView];
    
    if (tableView == _leftTableView) {
        MHFutuerWeatherModel *model = [self futureWeatherArrayWithDict:_leftArr][indexPath.row];
        cell.futureWeather = model;

    }
    if (tableView == _midTableView) {
        MHFutuerWeatherModel *model = [self futureWeatherArrayWithDict:_midArr][indexPath.row];
        cell.futureWeather = model;

    }
    if (tableView == _rightTableView) {
        MHFutuerWeatherModel *model = [self futureWeatherArrayWithDict:_rigthArr][indexPath.row];
        cell.futureWeather = model;
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _leftTableView) {
        return [self futureWeatherArrayWithDict:_leftArr].count;
    }
    if (tableView == _midTableView) {
        return [self futureWeatherArrayWithDict:_midArr].count;
           }
    if (tableView == _rightTableView) {
       return [self futureWeatherArrayWithDict:_rigthArr].count;
    }
    return 0;
}
@end
