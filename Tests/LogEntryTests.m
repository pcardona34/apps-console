#import <Foundation/Foundation.h>
#import "LogEntry.h"
int main(void)
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];
  LogEntry *entry = [LogEntry entryWithJournalLine:@"{\"MESSAGE\":\"Disk failure\\nMore detail\",\"SYSLOG_IDENTIFIER\":\"kernel\",\"_PID\":\"42\",\"PRIORITY\":\"3\",\"__REALTIME_TIMESTAMP\":\"1700000000123456\",\"_SYSTEMD_UNIT\":\"storage.service\"}"];
  NSCAssert([entry.severity isEqual:@"Error"], @"Severity parsed");
  NSCAssert([entry.process isEqual:@"kernel [42]"], @"Process and PID parsed");
  NSCAssert([entry.time hasSuffix:@".123"], @"Microsecond timestamp converted");
  NSCAssert([entry matchesText:@"FAILURE" process:@"KERNEL" maximumPriority:4], @"Case insensitive combined filters");
  NSCAssert([entry matchesText:@"storage.service" process:@"42" maximumPriority:7], @"Search metadata and PID");
  NSCAssert(![entry matchesText:@"" process:@"" maximumPriority:2], @"Severity excludes less severe messages");
  NSCAssert(![entry matchesText:@"missing" process:@"" maximumPriority:7], @"Nonmatching search excluded");
  NSCAssert(![entry matchesText:@"" process:@"other" maximumPriority:7], @"Nonmatching process excluded");
  NSCAssert([LogEntry entryWithJournalLine:@"broken"] == nil, @"Invalid JSON ignored");
  NSCAssert([LogEntry entryWithJournalLine:@"[]"] == nil, @"Nonobject JSON ignored");
  LogEntry *binary = [LogEntry entryWithJournalLine:@"{\"MESSAGE\":[72,105]}"];
  NSCAssert([binary.message isEqual:@"Hi"], @"Journal binary message decoded");
  LogEntry *plain = [LogEntry entryWithTextLine:@"Sep 28 host daemon: hello"];
  NSCAssert([plain matchesText:@"DAEMON" process:@"" maximumPriority:7], @"Plain text searchable");
  NSCAssert(![plain matchesText:@"" process:@"" maximumPriority:4], @"Unknown priority not misclassified");
  NSLog(@"All log parsing and filtering tests passed.");
  [pool drain]; return 0;
}
