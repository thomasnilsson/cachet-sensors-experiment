//
//  ViewController.m
//  PedometerApp
//
//  Created by Thomas Nilsson on 08/06/2018.
//  Copyright © 2018 Thomas Nilsson. All rights reserved.
//

#import "ViewController.h"
@import CoreMotion;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) CMPedometer *pedometer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _label.text = @"Hej med dig!";
    
    // start live tracking
    [self.pedometer startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
        
        // this block is called for each live update
        [self updateLabels:pedometerData];
        
    }];
    
}

- (CMPedometer *)pedometer {
    
    if (!_pedometer) {
        _pedometer = [[CMPedometer alloc]init];
    }
    return _pedometer;
}

- (void)updateLabels:(CMPedometerData *)pedometerData {
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.maximumFractionDigits = 2;
    
    // step counting
    if ([CMPedometer isStepCountingAvailable]) {
        self.label.text = [NSString stringWithFormat:@"Steps walked: %@", [formatter stringFromNumber:pedometerData.numberOfSteps]];
    } else {
        self.label.text = @"Step Counter not available.";
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
