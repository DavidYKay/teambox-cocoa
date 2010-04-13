//
//  ConversationModel.h
//  Teambox
//
//  Created by Alejandro JL on 13/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class ActivityModel;

@interface ConversationModel :  NSManagedObject  
{
}

@property (nonatomic, retain) NSDate * deleted_at;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) ActivityModel * Activity;

@end



