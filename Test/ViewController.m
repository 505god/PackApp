//
//  ViewController.m
//  Test
//
//  Created by 邱成西 on 2017/5/11.
//  Copyright © 2017年 邱大侠. All rights reserved.
//

#import "ViewController.h"
#import "SWAPIManager.h"
#import "SWKeyValueStore.h"
#import "Routable.h"
#import "SWLoginViewController.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /*
    NSInteger xx = [[SWAPIManager sharedInstance] loginWithParameters:@{@"method":@"checkpost",@"phone":@"13915563924"} methodType:1 success:^(id responseObject) {
        NSLog(@"111");
    } failure:^(NSString *errorInfo) {
        NSLog(@"222");
    }];
     */
    
    /*
    [[SWKeyValueStore sharedInstance] createTableWithName:@"login"];
    [[SWKeyValueStore sharedInstance] putObject:@{@"name":@"sss",@"pwd":@"ddd"} withId:@"3" intoTable:@"login"];
    
    id object = [[SWKeyValueStore sharedInstance] getObjectById:@"3" fromTable:@"login"];

    NSLog(@"object = %@",object);
     */
    
    [[Routable sharedRouter] setNavigationController:self.navigationController];
    
    [[Routable sharedRouter] map:@"login/:name/:pwd" toController:[SWLoginViewController class]];
}

- (IBAction)tap:(id)sender {
    [[Routable sharedRouter] open:@"login/sss/dddd"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
