//
//  SWLoginViewController.m
//  Test
//
//  Created by 邱成西 on 2017/5/12.
//  Copyright © 2017年 邱大侠. All rights reserved.
//

#import "SWLoginViewController.h"

@interface SWLoginViewController ()

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *password;

@end

@implementation SWLoginViewController

- (id)initWithRouterParams:(NSDictionary *)params {
    if ((self = [self initWithNibName:nil bundle:nil])) {
        self.title = @"Test";
        
        self.name = params[@"name"];
        
        self.password = params[@"pwd"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
