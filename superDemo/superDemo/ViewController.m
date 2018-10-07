//
//  ViewController.m
//  superDemo
//
//  Created by 马天野 on 2018/10/8.
//  Copyright © 2018 Maty. All rights reserved.
//

#import "ViewController.h"
#import "TYPerson.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    id cls = [TYPerson class];
    
    void *obj = &cls;
    
    [(__bridge id)obj log];
    
}


@end
