//
//  User.h
//  SpinCity
//
//  Created by Tan, CY on 27/1/15.
//  Copyright (c) 2015 Element 84, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * plan;
@property (nonatomic, retain) NSNumber * customer_id;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) NSString * mobile;

@end
