//
//  TrackingViewController.h
//  iBeaconExample
//
//  Created by 이승희 on 2015. 12. 19..
//  Copyright © 2015년 pangaea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BleModuleViewController.h"
@interface TrackingViewController : BleModuleViewController <CLLocationManagerDelegate, ChildModuleDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) IBOutlet UITableView *trackingTableView;

@end
