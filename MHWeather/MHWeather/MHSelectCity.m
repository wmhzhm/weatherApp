//
//  MHSelectCity.m
//  MHWeather
//
//  Created by wmh—future on 16/6/10.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import "MHSelectCity.h"
@interface MHSelectCity()<UITextFieldDelegate>

@end

@implementation MHSelectCity
- (IBAction)clickedHomeBtn {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"放弃定义城市并返回");
    }];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
