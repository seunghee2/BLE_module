//
//  TransmitViewController.h
//  iBeaconExample
//
//  Created by 이승희 on 2015. 12. 19..
//  Copyright © 2015년 pangaea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>
#import "BleModuleViewController.h"

@interface TransmitViewController : BleModuleViewController <CLLocationManagerDelegate, CBPeripheralManagerDelegate, ChildModuleDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) NSDictionary *beaconPeripheralData;
@property (strong, nonatomic) CBPeripheralManager * peripheralManager;

@end
