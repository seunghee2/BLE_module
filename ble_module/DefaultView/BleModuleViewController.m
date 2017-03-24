//
//  BleModuleViewController.m
//  ble_module
//
//  Created by 이승희 on 2015. 12. 19..
//  Copyright © 2015년 pangaea. All rights reserved.
//

#import "BleModuleViewController.h"

@interface BleModuleViewController ()

@end

@implementation BleModuleViewController
#pragma mark - Public Variable Initializer
- (NSArray *)uuidList
{
    if (!_uuidList ) {
        _uuidList = [[NSArray alloc] initWithObjects:
                     UUID_ILOCATE_1
                     , UUID_ILOCATE_2
                     , UUID_ILOCATE_3
                     , UUID_ILOCATE_ETC
                     , nil];
    }
    
    return _uuidList;
}

- (UIAlertController *)uuidAlert
{
    if (!_uuidAlert ) {
        _uuidAlert = [UIAlertController alertControllerWithTitle:@"안내"
                                                         message:@"UUID를 선택해주세요"
                                                  preferredStyle:(UIAlertControllerStyleActionSheet)];
        
        for ( NSString * uuidString in self.uuidList ) {
        
            UIAlertAction * uuidActionItem = [UIAlertAction actionWithTitle:uuidString
                                                             style:(UIAlertActionStyleDefault)
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               [self dismissViewControllerAnimated:YES completion:^{
                                                                   NSLog(@"Action Completion");
                                                               }];
                                                               self.selectedUUIDString = uuidString;
                                                               NSLog(@"selectedUUIDString = %@", self.selectedUUIDString);
                                                               [self.childDelegate setUUIDtoLabel:self.selectedUUIDString];
                                                           }];
            [_uuidAlert addAction:uuidActionItem];
        }
    }
    
    return _uuidAlert;
}

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (NSString *)getDateTime{
    NSDate * date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
//    NSLog(@"getDateTime: %@", date);
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString * strDate = [formatter stringFromDate:date];
    return strDate;
}


- (IBAction)backPress:(UIButton *)sender
{
    [[self navigationController]popViewControllerAnimated:YES];
}

- (IBAction)selectUUID:(id)sender {
    UIViewController * childView = (UIViewController *)self.childDelegate;
    self.uuidAlert.popoverPresentationController.sourceView = childView.view;
    self.uuidAlert.popoverPresentationController.sourceRect = CGRectMake(childView.view.bounds.size.width / 2.0, childView.view.bounds.size.height / 2.0, 1.0, 1.0);
    // this is the center of the screen currently but it can be any point in the view
    [self presentViewController:self.uuidAlert animated:YES completion:^{
        NSLog(@"slectedUUID Completion");
    }];
}


@end
