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

@property(strong, nonatomic) NSArray *images;

@property(assign, nonatomic) int imageCount;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.images = @[[UIImage imageNamed:@"Blue Bird.jpg"], [UIImage imageNamed:@"Firefox.jpg"], [UIImage imageNamed:@"North Face.png"], [UIImage imageNamed:@"Wordpress.jpg"]];
    
    self.imageCount = 0;
    [self chooseImage];
    
    self.manager = [[CMMotionManager alloc] init];
    [self.manager startDeviceMotionUpdates];
    
    
    self.manager.accelerometerUpdateInterval = 0.1;
    
    //ViewController * __weak weakSelf = self;
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    CMAttitudeReferenceFrame frame = CMAttitudeReferenceFrameXArbitraryZVertical;
    //CMAttitudeReferenceFrame frame = CMAttitudeReferenceFrameXArbitraryCorrectedZVertical;
    //CMAttitudeReferenceFrame frame = CMAttitudeReferenceFrameXMagneticNorthZVertical;
    //CMAttitudeReferenceFrame frame = CMAttitudeReferenceFrameXTrueNorthZVertical;
    
    [self.manager startDeviceMotionUpdatesUsingReferenceFrame:frame toQueue:queue withHandler:^(CMDeviceMotion *data, NSError *error) {
        //do work here
        //double yaw = data.attitude.yaw;
        double x = data.userAcceleration.x;
        double y = data.userAcceleration.y;
        double z = data.userAcceleration.z;
        
        double bump = sqrt(pow(x, 2)+pow(y, 2)+pow(z, 2));
        if(bump > 3.0){
            self.imageCount++;
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // update UI here
            
            //weakSelf.imageView.transform = CGAffineTransformMakeRotation(yaw);
            //[self chooseImage:yaw];
            [self chooseImage];
        }];
    }];
}

-(void) chooseImage {
    self.imageView.image = self.images[self.imageCount %4];
}

//-(void) chooseImage:(double)yaw{
//    if(yaw <= M_PI_4){ // less than 45 degrees
//        if(yaw >= -M_PI_4) { // bigger than -45 degrees
//            self.imageView.image = self.images[0];
//        } else if(yaw >= -3.0*M_PI_4){
//            self.imageView.image = self.images[1];
//        } else{
//            self.imageView.image = self.images[2];
//        }
//    }else{
//        if(yaw <= 3.0*M_PI_4){
//            self.imageView.image = self.images[3];
//        } else{
//            self.imageView.image = self.images[2];
//        }
//    }
//}

@end
