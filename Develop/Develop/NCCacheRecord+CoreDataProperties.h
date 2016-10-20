//
//  NCCacheRecord+CoreDataProperties.h
//  Develop
//
//  Created by Artem Shimanski on 20.10.16.
//  Copyright © 2016 Artem Shimanski. All rights reserved.
//

#import "NCCacheRecord+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface NCCacheRecord (CoreDataProperties)

+ (NSFetchRequest<NCCacheRecord *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, copy) NSDate *expireDate;
@property (nullable, nonatomic, copy) NSString *key;
@property (nullable, nonatomic, copy) NSString *account;
@property (nullable, nonatomic, retain) NCCacheRecordData *data;

@end

NS_ASSUME_NONNULL_END