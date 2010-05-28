//
//  PageModel.h
//  Teambox Mac
//
//  Created by Alejandro JL on 18/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class ActivityModel;

@interface PageModel :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * page_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* Activity;

@end


@interface PageModel (CoreDataGeneratedAccessors)
- (void)addActivityObject:(ActivityModel *)value;
- (void)removeActivityObject:(ActivityModel *)value;
- (void)addActivity:(NSSet *)value;
- (void)removeActivity:(NSSet *)value;

@end

