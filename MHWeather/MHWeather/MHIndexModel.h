//
//  MHIndexModel.h
//  MHWeather
//
//  Created by wmh—future on 16/6/11.
//  Copyright © 2016年 wmh—future. All rights reserved.
//
//指标模型以及数据格式
/*
 
 index: [  //指标列表
 {
 name: "感冒指数", //指数指标1名称
 code: "gm",     //指标编码
 index: "",      //等级
 details: "各项气象条件适宜，发生感冒机率较低。但请避免长期处于空调房间中，以防感冒。",//描述
 otherName: "" //其它信息
 },
 {
 code: "fs",
 details: "属中等强度紫外辐射天气，外出时应注意防护，建议涂擦SPF指数高于15，PA+的防晒护肤品。",
 index: "中等",
 name: "防晒指数",
 otherName: ""
 },
 {
 code: "ct",
 details: "天气炎热，建议着短衫、短裙、短裤、薄型T恤衫等清凉夏季服装。",
 index: "炎热",
 name: "穿衣指数",
 otherName: ""
 },
 {
 code: "yd",
 details: "有降水，推荐您在室内进行低强度运动；若坚持户外运动，须注意选择避雨防滑并携带雨具。",
 index: "较不宜",
 name: "运动指数",
 otherName: ""
 },
 {
 code: "xc",
 details: "不宜洗车，未来24小时内有雨，如果在此期间洗车，雨水和路上的泥水可能会再次弄脏您的爱车。",
 index: "不宜",
 name: "洗车指数",
 otherName: ""
 },
 {
 code: "ls",
 details: "有降水，不适宜晾晒。若需要晾晒，请在室内准备出充足的空间。",
 index: "不宜",
 name: "晾晒指数",
 otherName: ""
 }
 */
#import <Foundation/Foundation.h>

@interface MHIndexModel : NSObject
@property (copy ,nonatomic) NSString *code;
@property (copy ,nonatomic) NSString *details;
@property (copy ,nonatomic) NSString *index;
@property (copy ,nonatomic) NSString *name;
@property (copy ,nonatomic) NSString *otherName;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
