# uptifier - Unix system updater &amp; notifier

## Prerequisities

- `mutt`
- `nullmailer`

## nullmailer setup

1. Follow the guide on https://wiki.debian.org/nullmailer
2. In addition, create file `/etc/nullmailer/forced-from`, which has the email address that corresponds to your setup in `/etc/nullmailer/remotes` (for example, alice@example.com)


## uptifier setup

After the nullmailer is setup, create a *cron job* for the `uptifier.sh` by running the command `crontab -e`.

For example, to run the uptifier every sunday at midnight, append the file with
`0 0 * * 7 /path/to/uptifier.sh`