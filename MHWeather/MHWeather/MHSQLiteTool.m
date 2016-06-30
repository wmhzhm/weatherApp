//
//  MHSQLiteTool.m
//  音乐播放器_1.0
//
//  Created by wmh—future on 16/3/21.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import "MHSQLiteTool.h"
#import "MHSelectCity.h"
#import "MHCityModel.h"


@implementation MHSQLiteTool
//创建数据库实例
static sqlite3 *_db;

+ (void)initialize
{
    //打开数据库
    //获取沙盒路径
    NSString *fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"city.sqlite"];
    NSLog(@"沙盒路径-------: %@",fileName);
    int result = sqlite3_open(fileName.UTF8String/*OC字符串转为C语言Char类型字符串*/, &_db);
    if (result == SQLITE_OK) {
        NSLog(@"打开数据库成功");
        //成功之后自动创建表
        //创建t_city
        //cityID城市编码  cityName:城市名  cityPingYing：城市拼音  cityDistrict:城市市区名  cityProvince：城市所在省名
        const char *sql = "create table if not exists t_city (cityID int primary key,cityName text,cityPingYing text,cityDistrict text,cityProvince text);";
        [MHSQLiteTool createTable:sql named:@"t_city"];
        }else{
        NSLog(@"打开数据库失败");
    }
     //初始化分组
     const char *sql = "select * from t_city;";
    sqlite3_stmt *stmt = NULL;
    sqlite3_prepare_v2(_db, sql, -1, &stmt, NULL);
    if (sqlite3_step(stmt) == SQLITE_ROW) {
        return;
    }else{
        //添加内容
        [MHSelectCity upDateCityModelWithCityName:@"南昌"];
        [MHSelectCity upDateCityModelWithCityName:@"北京"];
        [MHSelectCity upDateCityModelWithCityName:@"上海"];
        
    }
}

////创建表
+ (void)createTable:(const char *)sql named:(NSString *)tableName
{
    char *errorMes = NULL;
    int result = sqlite3_exec(_db, sql, NULL, NULL, &errorMes);
    if (result == SQLITE_OK) {
        NSLog(@"建表成功");
    }else{
        NSLog(@"建表失败,错误为:%s",errorMes);
    }
}

//根据城市模型添加城市数据
+ (void)addCityWithCityModel:(MHCityModel *)model 
{
     //cityID城市编码  cityName:城市名  cityPingYing：城市拼音  cityDistrict:城市市区名  cityProvince：城市所在省名
    NSString *sql = [NSString stringWithFormat:@"insert into t_city (cityID,cityName,cityPingYing,cityDistrict,cityProvince) values('%ld','%@','%@','%@','%@');",(long)model.area_id,model.name_cn,model.name_en,model.district_cn,model.province_cn];
        char *errorMes = NULL;
        sqlite3_exec(_db, sql.UTF8String/*将NSString转为Char类型*/, NULL, NULL, &errorMes);
    NSLog(@"添加成功:%@",model.name_cn);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RegistreCompletionNotification" object:nil userInfo:nil];
}


+ (void)deleteCityWithModel:(MHCityModel *)model
{
    NSString *sql = [NSString stringWithFormat:@"delete from t_city where cityID = %ld",(long)model.area_id];
    char *errorMes = NULL;
    sqlite3_exec(_db, sql.UTF8String/*将NSString转为Char类型*/, NULL, NULL, &errorMes);
    NSLog(@"删除成功:%@",model.name_cn);
}

+ (NSMutableArray *)searchCityArray
{
    NSMutableArray *citys = nil;
    //定义sql语句
    const char *sql = "select * from t_city;";
    //定义结果集stmt
    sqlite3_stmt *stmt = NULL;
    //检测SQL语句的合法性
    int result = sqlite3_prepare_v2(_db, sql, -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"查询语句合法");
        citys = [NSMutableArray array];
        while (sqlite3_step(stmt) == SQLITE_ROW) {//查询到数据的时候
            //获得该行的数据
            MHCityModel *city = [[MHCityModel alloc] init];
            //获得第0列的cityID
            city.area_id = sqlite3_column_int(stmt, 0);
            //获得第1列的cityName
            const unsigned char *cityName = sqlite3_column_text(stmt, 1);
            city.name_cn = [NSString stringWithUTF8String:(const char *)cityName];
            //获得第二列的cityPingYing
            const unsigned char *cityPingYing = sqlite3_column_text(stmt, 2);
            city.name_en = [NSString stringWithUTF8String:(const char *)cityPingYing];
            //获得第3列的cityDistrict
            const unsigned char *cityDistrict = sqlite3_column_text(stmt, 3);
            city.district_cn = [NSString stringWithUTF8String:(const char *)cityDistrict];
            //获得第4列的cityProvince
            const unsigned char *cityProvince = sqlite3_column_text(stmt, 4);
            city.province_cn = [NSString stringWithUTF8String:(const char *)cityProvince];
            
            //把分组数据添加到数组
            [citys addObject:city];
        }
    }
    return citys;
}


@end
