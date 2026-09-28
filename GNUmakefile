SHELL = /bin/sh
include $(GNUSTEP_MAKEFILES)/common.make

APP_NAME = Console
Console_OBJC_FILES = main.m LogEntry.m ConsoleController.m
Console_RESOURCE_FILES = Resources/Console.svg Resources/Console.png
Console_APPLICATION_ICON = Console.png
Console_MAIN_MODEL_FILE =
Console_PRINCIPAL_CLASS = NSApplication
ADDITIONAL_OBJCFLAGS = -Wall

include $(GNUSTEP_MAKEFILES)/application.make

.PHONY: check
check::
	clang `gnustep-config --objc-flags` -I. Tests/LogEntryTests.m LogEntry.m -o /tmp/console-log-tests `gnustep-config --base-libs`
	/tmp/console-log-tests
