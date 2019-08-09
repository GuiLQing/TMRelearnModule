//
//  TMViewController.m
//  TMRelearnModule
//
//  Created by gui950823@126.com on 08/05/2019.
//  Copyright (c) 2019 gui950823@126.com. All rights reserved.
//

#import "TMViewController.h"
#import "TMRelearnManager.h"

@interface TMViewController ()

@end

@implementation TMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.redColor;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:[NSBundle.mainBundle pathForResource:@"DataSource" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    [TMRelearnManager.defaultManager pushToRelearnListVCBy:self.navigationController dataSource:dic[@"Data"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
