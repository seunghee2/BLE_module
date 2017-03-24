//
//  TransmitTableViewCell.m
//  ble_module
//
//  Created by 이승희 on 2015. 12. 19..
//  Copyright © 2015년 pangaea. All rights reserved.
//

#import "TransmitTableViewCell.h"

@implementation TransmitTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setWithTransmitData:(TransmitData *)transmitData
{
    [self.indexLabel setText:transmitData.index];
    [self.datetimeLabel setText:transmitData.datetime];
    [self.uuidLabel setText:transmitData.uuidString];
    [self.majorLabel setText:transmitData.major];
    [self.minorLabel setText:transmitData.minor];
    [self.intervalLabel setText:transmitData.interval];
    
}

@end
