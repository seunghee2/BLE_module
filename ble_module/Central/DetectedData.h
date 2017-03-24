//
//  DetectedData.h
//  ble_module
//
//  Created by 이승희 on 2015. 12. 19..
//  Copyright © 2015년 pangaea. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface DetectedData : NSObject
@property (nonatomic, retain) NSString * index;
@property (nonatomic, retain) NSString * timeStamp;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSString * major;
@property (nonatomic, retain) NSString * minor;
@property (nonatomic, retain) NSString * interval;
@property (nonatomic, retain) NSString * power;
@property (nonatomic, retain) NSString * rssi;
@end
