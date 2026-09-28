#import <AppKit/AppKit.h>

@interface ConsoleController : NSObject <NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate>
{
  NSWindow *_window;
  NSTableView *_table;
  NSTextView *_detail;
  NSTextField *_search, *_process, *_status, *_sourceLabel;
  NSPopUpButton *_severity;
  NSButton *_pause, *_follow;
  NSMutableArray *_entries, *_visible;
  NSTask *_task;
  NSFileHandle *_output, *_errors;
  NSMutableData *_pending;
  NSString *_filePath, *_diagnostic;
  NSTimer *_refreshTimer;
  BOOL _journal, _paused, _dirty;
}
@end
