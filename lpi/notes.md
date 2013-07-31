
## 12 - System and Process Information

Information about running processes is found in `/proc`, a virtual filesystem. Can inspect processes by PID to access their command line params, memory usage, environment variables, path to executable, file descriptors, (virtual) memory, mount points, thread and general status information. Also:

  * /proc/net
  * /proc/sys/fs
  * /proc/sys/kernel
  * /proc/sys/net
  * /proc/sys/vm
  * /proc/sysvipc
  
uname() system call can be used to get a bunch of information about the running system - implementation name, node name, release level, hardware.

## 36 - Process Resources

Look up a process's resource usage with the `getrusage()` system call. Struct is filled with resource usage information. Can inspect resource usage for process, thread, or all process + children.

Types of resource information returned: CPU time used (user/system), memory usage, page faults, swap, block operations, IPC messages, context switches.

Process resource limits can be get/set using `ulimit` shell builtin (values propagate to spawned processes), or with `getrlimit()` and `setrlimit()` syscalls. Every setting has a soft and hard limit. Non-privileged users can set soft limits anywhere up to hard limit, as well as irreversibly decrease hard limit.

Specific resource limits: max virtual memory, max core dump size, max CPU tie, max size of data segments, max filesize, max virtual memory locked to physical memory, max msg queue bytes, max nice level, max # of open files, max # of procs, and a few more. Some of these limits are per process, others are user-wide.

## 37 - Daemons

### Daemonizing

  * fork(), setsid(), clear umask, cd to /, close all file descriptors, reopen stdin/stdout/stderr descriptors to /dev/null
  * catch SIGHUP to reload config/reopen logfile. SIGHUP is good because daemon has no controlling terminal (kernel only sends SIGHUP to processes when controlling terminal hangs up)
  
### Syslog

  * /dev/log is unix datagram socket that writes to syslogd
  * syslog API - openlog(), syslog(), closelog(), setlogmask()
  * priority = facility | level