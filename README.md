# Console

A native GNUstep desktop application for watching system logs.

## Build and run

With GNUstep Base, GUI, Make, an Objective-C compiler, and a GUI backend installed:

```sh
. /usr/GNUstep/System/Library/Makefiles/GNUstep.sh
make
openapp ./Console.app
```

Run `make check` for parsing and filtering tests. `make install` installs the application into the configured GNUstep application directory.

## Using Console

- The system journal opens with the latest 1,000 entries and follows new messages.
- Search matches text in messages, process names, and journal metadata, ignoring case. Process narrows results by process name or PID. The level menu filters by severity. These filters work together.
- Select a row to read the complete message and journal fields in the resizable detail pane. Use Copy Message to copy them.
- Pause freezes the displayed rows while collection continues. Resume shows the current retained messages. Follow newest controls automatic scrolling.
- Clear clears the in-memory history; it does not delete system logs.
- Open Log follows a text file, including replacement after rotation, using `tail -F`. Text files retain their original lines; their level is Unknown and their process is shown as Log file. Use Search to find process names in those lines.
- System Journal returns to journald. When journalctl is unavailable, Console tries `/var/log/syslog`, `/var/log/messages`, then `/var/log/system.log`.

Console retains the latest 10,000 records to bound history. Paused rows are a snapshot; changing a filter reapplies it to the latest retained history. Only messages readable by your current account are available. Reader errors appear in the status line (hover for the complete text). Reopen the source to reconnect if the reader exits. Console never requests elevated privileges or modifies log files.
