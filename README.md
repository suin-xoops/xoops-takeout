# xoops-takeout

Export XOOPS database and files fully.

## Features

* Archive XOOPS files and MySQL dump
* Cron job support: xoops-takeout can be used as cron job

## Usage


```
$ ./xoops-takeout.sh </path/to/mainfile.php> </path/to/export/directory>
```

Example:

```
$ ./xoops-takeout.sh /var/www/html/mainfile.php /var/backup
```

## Cron Job Example

Daily back up (back up XOOPS 4 o'clock every day)

```
0 4 * * * /home/suin/bin/xoops-takeout.sh  /var/www/html/mainfile.php  /home/suin/backup
```

## License

MIT License