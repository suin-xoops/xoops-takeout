# xoops-takeout

Export XOOPS database and files fully.

## Features

* Archive XOOPS files and MySQL dump
* Cron job support
  * xoops-takeout can be used as cron job
  * Archive rotatetion

## Basic Usage


```
$ ./xoops-takeout.sh </path/to/mainfile.php> </path/to/export/directory>
```

Example:

```
$ ./xoops-takeout.sh /var/www/html/mainfile.php /var/backup
```

## Usage for cron job

Daily back up (back up XOOPS 4 o'clock every day)

```
0 4 * * * /home/suin/bin/xoops-takeout.sh  /var/www/html/mainfile.php  /home/suin/backup > /dev/null 2&>1
```

### Archive rotation for cron deriven backup

xoops-takeout can delete old backup archives with specifying `rotate-limit`.

```
$ ./xoops-takeout.sh </path/to/mainfile.php> </path/to/export/directory> <rotate-limit>
```

Example: Keep 10 latest archives

```
$ ./xoops-takeout.sh /var/www/html/mainfile.php /var/backup 10
```

## License

MIT License