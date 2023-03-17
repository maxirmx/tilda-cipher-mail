#!/bin/bash
# cron job
#
# Tilda daemon
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
JSONFILE="/var/$SERVICENAME/data.json"
ENCJSONFILE="/var/$SERVICENAME/data.enc.json"
CSVFILE="/var/$SERVICENAME/data.csv"
ENCCSVFILE="/var/$SERVICENAME/data.enc.csv"
CERTFILE="/etc/$SERVICENAME/certificate_1801993.cer"
MSGFILE="/etc/$SERVICENAME/$SERVICENAME.msg"
LOGFILE="/var/$SERVICENAME/log.txt"
#LOGFILE="/dev/nul"
CRYPTCP=/opt/cprocsp/bin/amd64/cryptcp
EMAIL_FROM="sender-service <sender-service@${HOSTNAME}>"
EMAIL_TO="my@email"

echo -n "tilda-cipher-mail daemon started on ">>"$LOGFILE"
date>>"$LOGFILE"

rm -f "$TMPFILE"
rm -f "$JSONFILE"
rm -f "$CSVFILE"

if [[ -f "$DATAFILE" ]]; then
  flock -w 5 -x "$DATAFILE" -c "mv $DATAFILE $TMPFILE"
  sed '1s/^/[/;$!s/$/,/;$s/$/]/'  "$TMPFILE" > "$JSONFILE"
  /opt/"$SERVICENAME"/convert.php "$JSONFILE" "$CSVFILE"
else
  echo "Нет данных" > "$TMPFILE"
  echo "[ ]" > "$JSONFILE"
  echo " " > "$CSVFILE"
fi

rm -f "$ENCFILE"
rm -f "$ENCJSONFILE"
rm -f "$ENCCSVFILE"
"$CRYPTCP" -encr -f "$CERTFILE" "$TMPFILE" "$ENCFILE">>"$LOGFILE"
"$CRYPTCP" -encr -f "$CERTFILE" "$JSONFILE" "$ENCJSONFILE">>"$LOGFILE"
"$CRYPTCP" -encr -f "$CERTFILE" "$CSVFILE" "$ENCCSVFILE">>"$LOGFILE"

EMAIL="$SERVICENAME <${SERVICENAME}@1295435-cb87573.tw1.ru>"
mutt -e "my_hdr From:$EMAIL_FROM" -y -s "Данные от Tilda" -a "$ENCFILE" "$ENCJSONFILE" "$ENCCSVFILE" -- "$EMAIL_TO"<"$MSGFILE"

echo -n "tilda-cipher-mail daemon finished on ">>"$LOGFILE"
date>>"$LOGFILE"
