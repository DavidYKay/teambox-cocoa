//
//  ConversationModel.h
//  Teambox Mac
//
//  Created by Alejandro JL on 18/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class ActivityModel;

@interface ConversationModel :  NSManagedObject  
{
}

@property (nonatomic, retain) NSDate * deleted_at;
@property (nonatomic, retain) NSNumber * conversation_id;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSSet* Activity;

@end


@interface ConversationModel (CoreDataGeneratedAccessors)
- (void)addActivityObject:(ActivityModel *)value;
- (void)removeActivityObject:(ActivityModel *)value;
- (void)addActivity:(NSSet *)value;
- (void)removeActivity:(NSSet *)value;

@end

