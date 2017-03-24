//
//  TrackingTableViewCell.m
//  ble_module
//
//  Created by 이승희 on 2015. 12. 19..
//  Copyright © 2015년 pangaea. All rights reserved.
//

#import "TrackingTableViewCell.h"

@implementation TrackingTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setWithDetectedData:(DetectedData *)detectedData
{
    if (!detectedData) {
        return;
    }
    
    
    [self.uuidStringLabel setText:detectedData.uuid];
    [self.majorStringLabel setText:detectedData.major];
    [self.minorStringLabel setText:detectedData.minor];
    [self.rssiStringLabel setText:detectedData.rssi];
    [self.datetimeLabel setText:detectedData.timeStamp];
    [self.indexLabel setText:detectedData.index];
    [self.intervalStringLabel setText:detectedData.interval];
    [self setNeedsDisplay];
    
}
@end
