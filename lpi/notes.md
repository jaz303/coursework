

## 37 - Daemons

### Daemonizing

  * fork(), setsid(), clear umask, cd to /, close all file descriptors, reopen stdin/stdout/stderr descriptors to /dev/null
  * catch SIGHUP to reload config/reopen logfile. SIGHUP is good because daemon has no controlling terminal (kernel only sends SIGHUP to processes when controlling terminal hangs up)
  
### Syslog

  * /dev/log is unix datagram socket that writes to syslogd
  * syslog API - openlog(), syslog(), closelog(), setlogmask()
  * priority = facility | level