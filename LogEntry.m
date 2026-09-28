#import "LogEntry.h"

static NSString *StringValue(id value)
{
  if ([value isKindOfClass:[NSString class]]) return value;
  if ([value isKindOfClass:[NSNumber class]]) return [value stringValue];
  if ([value isKindOfClass:[NSArray class]])
    {
      NSMutableData *bytes = [NSMutableData data];
      for (id item in value)
        {
          if (![item isKindOfClass:[NSNumber class]]) return [value description];
          unsigned char byte = [item unsignedCharValue];
          [bytes appendBytes:&byte length:1];
        }
      NSString *decoded = [[[NSString alloc] initWithData:bytes encoding:NSUTF8StringEncoding] autorelease];
      return decoded ?: [value description];
    }
  return @"";
}

@implementation LogEntry
@synthesize time = _time, process = _process, message = _message, details = _details, priority = _priority;
+ (instancetype)entryWithJournalLine:(NSString *)line
{
  id record = [NSJSONSerialization JSONObjectWithData:[line dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
  if (![record isKindOfClass:[NSDictionary class]]) return nil;
  LogEntry *entry = [[[self alloc] init] autorelease];
  entry.message = StringValue([record objectForKey:@"MESSAGE"]);
  NSString *process = StringValue([record objectForKey:@"SYSLOG_IDENTIFIER"]);
  if (![process length]) process = StringValue([record objectForKey:@"_COMM"]);
  if (![process length]) process = StringValue([record objectForKey:@"_SYSTEMD_UNIT"]);
  NSString *pid = StringValue([record objectForKey:@"_PID"]);
  entry.process = [pid length] ? [NSString stringWithFormat:@"%@ [%@]", process, pid] : process;
  NSString *priority = StringValue([record objectForKey:@"PRIORITY"]);
  entry.priority = [priority length] ? [priority integerValue] : -1;
  NSString *timestamp = StringValue([record objectForKey:@"__REALTIME_TIMESTAMP"]);
  if ([timestamp length])
    {
      NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
      [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
      entry.time = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue] / 1000000.0]];
    }
  else entry.time = @"—";
  NSMutableString *details = [NSMutableString stringWithFormat:@"%@\n\n", entry.message];
  for (NSString *key in [[record allKeys] sortedArrayUsingSelector:@selector(compare:)])
    [details appendFormat:@"%@: %@\n", key, StringValue([record objectForKey:key])];
  entry.details = details;
  return entry;
}
+ (instancetype)entryWithTextLine:(NSString *)line
{
  LogEntry *entry = [[[self alloc] init] autorelease];
  entry.time = @"—";
  entry.process = @"Log file";
  entry.message = line;
  entry.details = line;
  entry.priority = -1;
  return entry;
}
- (NSString *)severity
{
  NSArray *names = @[@"Emergency", @"Alert", @"Critical", @"Error", @"Warning", @"Notice", @"Info", @"Debug"];
  return _priority >= 0 && _priority < 8 ? [names objectAtIndex:_priority] : @"Unknown";
}
- (BOOL)matchesText:(NSString *)text process:(NSString *)process maximumPriority:(NSInteger)priority
{
  if (priority < 7 && (_priority < 0 || _priority > priority)) return NO;
  if ([process length] && [_process rangeOfString:process options:NSCaseInsensitiveSearch].location == NSNotFound) return NO;
  if (![text length]) return YES;
  return [_message rangeOfString:text options:NSCaseInsensitiveSearch].location != NSNotFound
    || [_process rangeOfString:text options:NSCaseInsensitiveSearch].location != NSNotFound
    || [_details rangeOfString:text options:NSCaseInsensitiveSearch].location != NSNotFound;
}
- (void)dealloc
{
  [_time release]; [_process release]; [_message release]; [_details release];
  [super dealloc];
}
@end
