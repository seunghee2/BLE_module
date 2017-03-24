//
//  BleModuleViewController.h
//  ble_module
//
//  Created by 이승희 on 2015. 12. 19..
//  Copyright © 2015년 pangaea. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UUID_ILOCATE_1 @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"
#define UUID_ILOCATE_2 @"5A4BCFCE-174E-4BAC-A814-092E77F6B7E5"
#define UUID_ILOCATE_3 @"74278BDA-B644-4520-8F0C-720EAF059935"
#define UUID_ILOCATE_ETC @"직접 입력"

@protocol ChildModuleDelegate <NSObject>

- (void) setUUIDtoLabel:(NSString *)uuidString ;

@end

@interface BleModuleViewController : UIViewController
@property (nonatomic, retain) NSArray * uuidList;
@property (nonatomic, retain) UIAlertController * uuidAlert;
@property (nonatomic, retain) NSString * selectedUUIDString;
@property (nonatomic) id<ChildModuleDelegate> childDelegate;

- (IBAction)backPress:(UIButton *)sender;
- (IBAction)selectUUID:(id)sender ;
- (NSString *)getDateTime;
@end
