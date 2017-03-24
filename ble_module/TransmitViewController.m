//
//  TransmitViewController.m
//  iBeaconExample
//
//  Created by 이승희 on 2015. 12. 19..
//  Copyright © 2015년 pangaea. All rights reserved.
//

#import "TransmitViewController.h"
#import "TransmitTableviewCell.h"
#import "TransmitData.h"

@interface TransmitViewController ()

@property (strong, nonatomic) IBOutlet UILabel *proximityUUIDLabel;
@property (strong, nonatomic) IBOutlet UILabel *majorLabel;
@property (strong, nonatomic) IBOutlet UILabel *minorLabel;
@property (strong, nonatomic) IBOutlet UILabel *accurancyLabel;
@property (strong, nonatomic) IBOutlet UITextField *uuidString_field;
@property (strong, nonatomic) IBOutlet UITextField *major_field;
@property (strong, nonatomic) IBOutlet UITextField *minor_field;

@property (strong, nonatomic) IBOutlet UITableView *transmitTableView;
@property (nonatomic) BOOL isReady;
@property (nonatomic, retain) NSMutableArray * transmitList;
@property (nonatomic) NSInteger indexCount;
@end

@implementation TransmitViewController

- (NSMutableArray *)transmitList {
    if ( !_transmitList ) {
        _transmitList = [[NSMutableArray alloc]init];
    }
    
    return _transmitList;
}

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initBeacon];
//    [self setLabel];

    self.isReady = NO;
    self.childDelegate = self;
    self.indexCount = 0;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.beaconPeripheralData = nil;
    self.beaconRegion = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Child Delegate Method
- (void)setUUIDtoLabel:(NSString *)uuidString {
    if ([uuidString isEqualToString:UUID_ILOCATE_ETC]) {
        [self.uuidString_field setEnabled:YES];
        [self.uuidString_field becomeFirstResponder];
        [self.uuidString_field setText:@""];
        return;
    }
    
    [self.uuidString_field setEnabled:NO];
    [self.uuidString_field setText: self.selectedUUIDString];
}

#pragma mark - IBAction
- (IBAction)transmitBeacon:(UIButton *)sender {
    self.beaconPeripheralData = [self.beaconRegion peripheralDataWithMeasuredPower:nil];
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                                     queue:nil
                                                                   options:nil];
}

- (IBAction)doApply:(id)sender {
    
    // Check UUID
    if ( [self.uuidString_field.text isEqualToString:@""] ) {
        UIAlertController * uuidAlert = [UIAlertController alertControllerWithTitle:@"안내" message:@"UUID를 선택해주세요" preferredStyle:(UIAlertControllerStyleAlert)];
        [self presentViewController:uuidAlert animated:YES completion:^{
            [NSThread sleepForTimeInterval:0.5];
            [uuidAlert dismissViewControllerAnimated:YES completion:nil];
        }];
        return;
    }
    
    // Check For Major Field
    if ([self.major_field.text isEqualToString:@""]) {
        UIAlertController * majorAlert = [UIAlertController alertControllerWithTitle:@"안내" message:@"Need to Major Value(Integer)" preferredStyle:(UIAlertControllerStyleAlert)];
        [self presentViewController:majorAlert animated:YES completion:^{
            [NSThread sleepForTimeInterval:0.5];
            [majorAlert dismissViewControllerAnimated:YES completion:nil];
        }];
        return;
    }
    
    // Check For Minor Field
    if ( [self.minor_field.text isEqualToString:@""]) {
        UIAlertController * minorAlert = [UIAlertController alertControllerWithTitle:@"안내" message:@"Need to Minor Value(Interger)" preferredStyle:(UIAlertControllerStyleAlert)];
        
        [self presentViewController:minorAlert animated:YES completion:^{
            [NSThread sleepForTimeInterval:0.5];
            [minorAlert dismissViewControllerAnimated:YES completion:nil];
        }];
        return;
    }
    
    [self initBeacon];
}
- (IBAction)doStop:(id)sender {
    if(!self.peripheralManager) {
        return;
    }
    
    [self.peripheralManager stopAdvertising];
}
- (IBAction)doStart:(id)sender {
    // Check Apply
    if ( !self.isReady ) {
        UIAlertController * startAlert = [UIAlertController alertControllerWithTitle:@"안내" message:@"Need to [Apply]" preferredStyle:(UIAlertControllerStyleAlert)];
        [self presentViewController:startAlert animated:YES completion:^{
            [NSThread sleepForTimeInterval:.5];
            [startAlert dismissViewControllerAnimated:YES completion:nil];
        }];
        return;
    }
    
    self.beaconPeripheralData = [self.beaconRegion peripheralDataWithMeasuredPower:nil];
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                                     queue:nil
                                                                   options:nil];
}

#pragma mark - Beacon Method
- (void)initBeacon {
    NSUUID * uuid = [[NSUUID alloc]initWithUUIDString:self.uuidString_field.text];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                major:self.major_field.text.intValue
                                                                minor:self.minor_field.text.intValue
                                                           identifier:@"com.motion.beaconmanager"];
    self.isReady = YES;
}

- (void)AddTransmitData {
    TransmitData * data = [[TransmitData alloc]init];
    
    data.uuidString = [NSString stringWithFormat:@"%@", self.uuidString_field.text];
    data.major = [NSString stringWithFormat:@"%@", self.major_field.text];
    data.minor = [NSString stringWithFormat:@"%@", self.minor_field.text];
    data.datetime = [self getDateTime];
 
    data.index = [NSString stringWithFormat:@"%ld", (long)self.indexCount];
    
    [self.transmitList addObject:data];
    self.indexCount++;
    
    [self.transmitTableView reloadData];
}

- (void)setLabel {
    [self.proximityUUIDLabel setText:self.beaconRegion.proximityUUID.UUIDString];
    [self.majorLabel setText:[NSString stringWithFormat:@"%@", self.beaconRegion.major]];
    [self.minorLabel setText:[NSString stringWithFormat:@"%@", self.beaconRegion.minor]];
    [self.accurancyLabel setText:self.beaconRegion.identifier];
}

#pragma mark - Peripheral Mnager Method
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        NSLog(@"Power On");
        [self.peripheralManager startAdvertising:self.beaconPeripheralData];
        [self AddTransmitData];
    } else if (peripheral.state == CBPeripheralManagerStatePoweredOff) {
        NSLog(@"Power Off");
        [self.peripheralManager stopAdvertising];
    }
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error {
    NSLog(@"Did Start Advertising");
}

#pragma mark - Table View Delegate Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.transmitList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellId = @"transmitCell";
    TransmitTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[TransmitTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
    }
    
    TransmitData * data = [self.transmitList objectAtIndex:indexPath.row];
    [cell setWithTransmitData:data];
    
    return cell;
}

@end
