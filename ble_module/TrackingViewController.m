//
//  TrackingViewController.m
//  iBeaconExample
//
//  Created by 이승희 on 2015. 12. 19..
//  Copyright © 2015년 pangaea. All rights reserved.
//

#import "TrackingViewController.h"
#import "DetectedData.h"
#import "TrackingTableViewCell.h"

#define TimeStamp ([[NSDate date] timeIntervalSince1970])

@interface TrackingViewController ()

@property (strong, nonatomic) IBOutlet UILabel *beaconFoundLabel;
@property (strong, nonatomic) IBOutlet UILabel *proximityUUID;
@property (strong, nonatomic) IBOutlet UILabel *MajorLabel;
@property (strong, nonatomic) IBOutlet UILabel *MinorLabel;
@property (strong, nonatomic) IBOutlet UILabel *AccurancyLabel;
@property (strong, nonatomic) IBOutlet UILabel *rssiLabel;
@property (strong, nonatomic) IBOutlet UILabel *DistanceLabel;

@property (strong, nonatomic) IBOutlet UITextField *dbm10cm_field;
@property (strong, nonatomic) IBOutlet UITextField *dbm1m_field;
@property (strong, nonatomic) IBOutlet UITextField *dbm10m_field;
@property (strong, nonatomic) IBOutlet UITextField *dbmFVS_field;
@property (strong, nonatomic) IBOutlet UITextField *uuid_field;
@property (strong, nonatomic) IBOutlet UITextField *major_field;
@property (strong, nonatomic) IBOutlet UITextField *minor_field;

@property (nonatomic) NSInteger indexCount;
@property (nonatomic, retain) NSMutableArray * detectedList;
@property (nonatomic, retain) NSMutableDictionary * intervalDic;
@end

@implementation TrackingViewController
#pragma mark - Private Method
- (NSMutableArray *)detectedList {
    if ( !_detectedList ) {
        _detectedList = [[NSMutableArray alloc]init];
    }
    
    return _detectedList;
}

- (NSMutableDictionary *)intervalDic {
    if(!_intervalDic ) {
        _intervalDic = [[NSMutableDictionary alloc]init];
    }
    
    return _intervalDic;
}

- (NSString *)makeIntervalKey:(CLBeacon *)beacon {
    if (!beacon)
        return nil;
    
    NSString * intervalKey = [NSString stringWithFormat:@"%@-%@-%@", beacon.proximityUUID.UUIDString, beacon.major.stringValue, beacon.minor.stringValue];
    
    return intervalKey;
}

- (double)updateInterval:(NSString *)intervalKey {
    if (!intervalKey)
        return 0;
    NSDate * date = [NSDate date];
    NSString * timeInMS = [NSString stringWithFormat:@"%lld", [@(floor([date timeIntervalSince1970] * 1000)) longLongValue]];
    NSLog(@"%@", timeInMS);
    // Get Timestamp
    NSString * interval = [self.intervalDic objectForKey:intervalKey];
    [self.intervalDic setObject:timeInMS forKey:intervalKey];
    // First Value Of this Key
    if (!interval)
        return 0;
    
    double  intervalDistance = timeInMS.doubleValue - interval.doubleValue;
    return intervalDistance;
}

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.locationManager =[[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
//    [self initRegion];
    self.childDelegate = self;
    self.indexCount = 0;
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if(self.beaconRegion) {
        [self.locationManager stopMonitoringForRegion:self.beaconRegion];
        [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    }
    self.beaconRegion = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - child Module Delegate
- (void)setUUIDtoLabel:(NSString *)uuidString {
    if ([uuidString isEqualToString:UUID_ILOCATE_ETC]) {
        [self.uuid_field setEnabled:YES];
        [self.uuid_field becomeFirstResponder];
        [self.uuid_field setText:@""];
        return;
    }
    
    [self.uuid_field setEnabled:NO];
    [self.uuid_field setText: self.selectedUUIDString];
}

#pragma mark - IBAction Method
- (IBAction)doStop:(id)sender {
    if(self.beaconRegion) {
        [self.locationManager stopMonitoringForRegion:self.beaconRegion];
        [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    }
}

- (IBAction)doStart:(id)sender {
    
    if ([self.uuid_field.text isEqualToString:UUID_ILOCATE_ETC]
        || [self.uuid_field.text isEqualToString:@""] ) {
        UIAlertController * uidAlert = [UIAlertController alertControllerWithTitle:@"안내" message:@"UUID를 확인해주세요" preferredStyle:(UIAlertControllerStyleAlert)];
        [self presentViewController:uidAlert animated:YES completion:^{
            [NSThread sleepForTimeInterval:.5];
            [uidAlert dismissViewControllerAnimated:YES completion:nil];
        }];
        return;
    }
    [self initRegion];
}

#pragma mark - CLLocation Manager Method
- (void) initRegion {
    NSUUID *uuid = [[NSUUID alloc]initWithUUIDString: self.uuid_field.text];
    self.beaconRegion =[[CLBeaconRegion alloc]initWithProximityUUID:uuid identifier:@"com.motion.beaconmanager"];
    self.beaconRegion.notifyEntryStateOnDisplay = YES;
    self.beaconRegion.notifyOnEntry = YES;
    self.beaconRegion.notifyOnExit = YES;
    
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startMonitoringForRegion:self.beaconRegion];

}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    NSLog(@"didStartMonitoringForRegion");
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"didEnterRegion");
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"didExitRegion");
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    self.beaconFoundLabel.text = @"No";
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region {
    for (CLBeacon * beacon in beacons ) {
        if (![beacon.proximityUUID.UUIDString isEqualToString:self.uuid_field.text]) {
            return;
        }
        
        NSString * major = [NSString stringWithFormat:@"%@",beacon.major];
        NSString * minor = [NSString stringWithFormat:@"%@", beacon.minor];
        
        // Major Filter Check
        if (![self.major_field.text isEqualToString:@""]) {
            if ( [major isEqualToString:self.major_field.text] ) {
                NSLog(@"Allow Major: %@", major);
            } else {
                NSLog(@"Not Allow Major Code:%@", major);
                return ;
            }
        }
        
        // Minor Filter Check
        if (![self.minor_field.text isEqualToString:@""]) {
            if ([minor isEqualToString:self.minor_field.text]) {
                NSLog(@"Allow Minor: %@", minor);
            } else {
                NSLog(@"Not Allow Minor Code: %@", minor);
            }
        }
        
        NSString * intervalKey = [self makeIntervalKey:beacon];
        double interval = [self updateInterval:intervalKey];
        
        DetectedData * detectData = [[DetectedData alloc]init];
        [detectData setIndex:[NSString stringWithFormat:@"%ld", (long)self.indexCount]];
        [detectData setUuid:[NSString stringWithFormat:@"%@", beacon.proximityUUID.UUIDString]];
        [detectData setMajor:[NSString stringWithFormat:@"%@", beacon.major]];
        [detectData setMinor:[NSString stringWithFormat:@"%@", beacon.minor]];
        [detectData setRssi:[NSString stringWithFormat:@"%ld", (long)beacon.rssi]];
        [detectData setTimeStamp:[self getDateTime]];
        [detectData setInterval:[NSString stringWithFormat:@"%lf", interval]];

        
        [self.detectedList addObject:detectData];
        [self.trackingTableView reloadData];
        
        self.indexCount++;
    }
}

#pragma mark - UITableViewDelegate Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.detectedList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellId = @"TrackingCell";
    TrackingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[TrackingTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
    }
    
    DetectedData * data =  [self.detectedList objectAtIndex:indexPath.row];
    [cell setWithDetectedData:data];
    
    return cell;
}


@end
