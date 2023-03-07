#!/bin/bash
# cron job
#
# Tilda callback
#
# @author  Максим Самсонов <maxim@samsonov.net>
# @copyright  2023 Максим Самсонов, его родственники и знакомые
# @license    http://www.opensource.org/license/mit-0 MIT
#

set -o errexit -o pipefail -o noclobber -o nounset

SERVICENAME="tilda-cipher-mail"
DATAFILE="/var/$SERVICENAME/data.txt"
TMPFILE="/var/$SERVICENAME/tmp.txt"
ENCFILE="/var/$SERVICENAME/data.enc.txt"
CERTFILE="/etc/$SERVICENAME/$SERVICENAME.cer"
MSGFILE="/etc/$SERVICENAME/$SERVICENAME.msg"
#LOGFILE="/var/$SERVICENAME/log.txt"
LOGFILE="/dev/nul"
CRYPTCP=/opt/cprocsp/bin/amd64/cryptcp
EMAIL_FROM="$SERVICENAME <${SERVICENAME}@${HOSTNAME}>"
EMAIL_TO="maxirmx@mail.ru"

echo -n "tilda-cipher-mail daemon started on ">>"$LOGFILE"
date>>"$LOGFILE"

rm -f "$TMPFILE"
if [[ -f "$DATAFILE" ]]; then
  flock -w 5 -x "$DATAFILE" -c "mv $DATAFILE $TMPFILE"
else
 echo "Нет данных" > "$TMPFILE"
fi

rm -f "$ENCFILE"
"$CRYPTCP" -encr -f "$CERTFILE" "$TMPFILE" "$ENCFILE">>"$LOGFILE"
rm "$TMPFILE"

EMAIL="$SERVICENAME <${SERVICENAME}@1295435-cb87573.tw1.ru>"
mutt -e "my_hdr From:$EMAIL_FROM" -y -s "Данные от Tilda" -a "$ENCFILE" -- "$EMAIL_TO"<"$MSGFILE"

echo -n "tilda-cipher-mail daemon finished on ">>"$LOGFILE"
date>>"$LOGFILE"
