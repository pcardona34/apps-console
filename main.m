#import <AppKit/AppKit.h>
#import "ConsoleController.h"

int main(int argc, const char **argv)
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];
  NSApplication *app = [NSApplication sharedApplication];
  ConsoleController *controller = [ConsoleController new];
  [app setDelegate:controller];
  [app run];
  [controller release];
  [pool drain];
  return 0;
}
