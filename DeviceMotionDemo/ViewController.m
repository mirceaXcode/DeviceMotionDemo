//
//  ViewController.m
//  DeviceMotionDemo
//
//  Created by Mircea Popescu on 10/3/18.
//  Copyright © 2018 Mircea Popescu. All rights reserved.
//

#import "ViewController.h"
@import CoreMotion;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) CMMotionManager *manager;

@property (assign, nonatomic) double x,y,z;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.imageView.image = [UIImage imageNamed:@"Square image.jpg"];
    self.manager = [[CMMotionManager alloc] init];
    [self.manager startDeviceMotionUpdates];
    
    
    self.manager.accelerometerUpdateInterval = 0.1;
    
    ViewController * __weak weakSelf = self;
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [self.manager startDeviceMotionUpdatesToQueue:queue withHandler:^(CMDeviceMotion *data, NSError *error) {
        //do work here
        double x = data.gravity.x;
        double y = data.gravity.y;
        
        double rotation = -atan2(x, -y);
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // update UI here
            
            weakSelf.imageView.transform = CGAffineTransformMakeRotation(rotation);
      
        }];
    }];
}




@end
