//
//  ViewController.m
//  TMRelearnModule
//
//  Created by 彭石桂 on 2019/8/7.
//  Copyright © 2019 GUI. All rights reserved.
//

#import "ViewController.h"
#import "TMRelearnManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.redColor;
    // Do any additional setup after loading the view.
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:[NSBundle.mainBundle pathForResource:@"DataSource" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    [TMRelearnManager.defaultManager pushToRelearnListVCBy:self.navigationController dataSource:dic[@"Data"]];
}


@end
