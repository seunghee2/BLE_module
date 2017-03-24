//
//  TransmitTableViewCell.h
//  ble_module
//
//  Created by 이승희 on 2015. 12. 19..
//  Copyright © 2015년 pangaea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransmitData.h"
@interface TransmitTableViewCell : UITableViewCell
@property (nonatomic, retain) IBOutlet UILabel * indexLabel;
@property (nonatomic, retain) IBOutlet UILabel * datetimeLabel;
@property (nonatomic, retain) IBOutlet UILabel * uuidLabel;
@property (nonatomic, retain) IBOutlet UILabel * majorLabel;
@property (nonatomic, retain) IBOutlet UILabel * minorLabel;
@property (nonatomic, retain) IBOutlet UILabel * intervalLabel;

- (void)setWithTransmitData:(TransmitData *)transmitData;
@end
