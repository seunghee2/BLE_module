//
//  TrackingTableViewCell.h
//  ble_module
//
//  Created by 이승희 on 2015. 12. 19..
//  Copyright © 2015년 pangaea. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "DetectedData.h"
@interface TrackingTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *indexLabel;
@property (strong, nonatomic) IBOutlet UILabel *uuidStringLabel;
@property (strong, nonatomic) IBOutlet UILabel *datetimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *majorStringLabel;
@property (strong, nonatomic) IBOutlet UILabel *minorStringLabel;
@property (strong, nonatomic) IBOutlet UILabel *intervalStringLabel;
@property (strong, nonatomic) IBOutlet UILabel *powerStringLabel;
@property (strong, nonatomic) IBOutlet UILabel *rssiStringLabel;

-(void)setWithDetectedData:(DetectedData *)detectedData;
@end
