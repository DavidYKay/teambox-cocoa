//
//  CommentModel.h
//  Teambox-Engine
//
//  Created by Alejandro JL on 26/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class ActivityModel;

@interface CommentModel :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * body_html;
@property (nonatomic, retain) NSString * target_type;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) NSNumber * project_id;
@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSNumber * target_id;
@property (nonatomic, retain) ActivityModel * Activity;

@end



