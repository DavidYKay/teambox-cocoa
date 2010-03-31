//
//  CommentModel.h
//  Teambox-Engine
//
//  Created by Alejandro JL on 31/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class ActivityModel;
@class UploadModel;

@interface CommentModel :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSNumber * previous_status;
@property (nonatomic, retain) NSString * body_html;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * assigned_id;
@property (nonatomic, retain) NSDate * deleted_at;
@property (nonatomic, retain) NSNumber * target_id;
@property (nonatomic, retain) NSString * target_type;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSNumber * previous_assigned_id;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) ActivityModel * Activity;
@property (nonatomic, retain) NSSet* Upload;

@end


@interface CommentModel (CoreDataGeneratedAccessors)
- (void)addUploadObject:(UploadModel *)value;
- (void)removeUploadObject:(UploadModel *)value;
- (void)addUpload:(NSSet *)value;
- (void)removeUpload:(NSSet *)value;

@end

