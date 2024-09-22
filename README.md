# .AppImage setup script
The AppImage format offers a highly convenient, plug-and-play approach for running applications with minimal effort. This is made possible by the way AppImage functions: much like containers, it encapsulates an application's dependencies and files within a single .AppImage file, allowing for seamless distribution and execution.

However, there is one minor inconvenience: running an AppImage application "out of the box" typically requires the user to open a terminal and execute the file manually. This script addresses that issue by streamlining the process, offering a simple icon setup for .AppImage files (by creating a .destop file, which you can find more information about at this link https://forums.debian.net/viewtopic.php?t=154052 ) and an easy "uninstall" option for more efficient management.

### Basic usage:
-h                          Display help message <br>
-i [app/path] [icon/path]   Set up application and make .desktop launcher <br>
-u [appname]                Delete application’s file, icon, directory and launcher files <br>
