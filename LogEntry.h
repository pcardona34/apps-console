#import <Foundation/Foundation.h>

@interface LogEntry : NSObject
{
  NSString *_time, *_process, *_message, *_details;
  NSInteger _priority;
}
@property(copy) NSString *time, *process, *message, *details;
@property NSInteger priority;
+ (instancetype)entryWithJournalLine:(NSString *)line;
+ (instancetype)entryWithTextLine:(NSString *)line;
- (NSString *)severity;
- (BOOL)matchesText:(NSString *)text process:(NSString *)process maximumPriority:(NSInteger)priority;
@end
