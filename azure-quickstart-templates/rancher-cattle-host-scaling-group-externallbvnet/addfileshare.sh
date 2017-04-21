#!/bin/bash

STORAGE_ACCOUNT="$1"
STORAGE_KEY="$2"

DATE_ISO=$(TZ=GMT date "+%a, %d %h %Y %H:%M:%S %Z")
VERSION="2016-05-31"
HEADER_RESOURCE="x-ms-date:$DATE_ISO\nx-ms-version:$VERSION"

shift
shift
numargs=$#
for ((i=1 ; i <= numargs ; i++))
do
        SHARE_OR_DIR_NAME="$1"
        if [[ $SHARE_OR_DIR_NAME == *"/"* ]]; then
                TYPE="directory"
        else
                TYPE="share"
        fi

        PUT_URL_RESOURCE="/$STORAGE_ACCOUNT/$SHARE_OR_DIR_NAME\nrestype:$TYPE"
        GET_URL_RESOURCE="/$STORAGE_ACCOUNT/\ncomp:list"
        PUT_STRING_TO_SIGN="PUT\n\n\n\n\n\n\n\n\n\n\n\n$HEADER_RESOURCE\n$PUT_URL_RESOURCE"
        GET_STRING_TO_SIGN="GET\n\n\n\n\n\n\n\n\n\n\n\n$HEADER_RESOURCE\n$GET_URL_RESOURCE"

        DECODED_KEY="$(echo -n $STORAGE_KEY | base64 -d -w0 | xxd -p -c256)"
        SIGN_PUT=$(printf "$PUT_STRING_TO_SIGN" | openssl dgst -sha256 -mac HMAC -macopt "hexkey:$DECODED_KEY" -binary |  base64 -w0)
        SIGN_GET=$(printf "$GET_STRING_TO_SIGN" | openssl dgst -sha256 -mac HMAC -macopt "hexkey:$DECODED_KEY" -binary |  base64 -w0)

        curl -X GET \
          -H "x-ms-date:$DATE_ISO" \
          -H "x-ms-version:$VERSION" \
          -H "Authorization: SharedKey $STORAGE_ACCOUNT:$SIGN_GET" \
          -H "Content-Length:0" \
          "https://$STORAGE_ACCOUNT.file.core.windows.net/?comp=list" | grep $SHARE_OR_DIR_NAME &> /dev/null

          if [ $? == 0 ]; then
            echo "File Share $SHARE_OR_DIR_NAME Already Exists!"
            exit 0
          fi

        shift

        curl -X PUT \
          -H "x-ms-date:$DATE_ISO" \
          -H "x-ms-version:$VERSION" \
          -H "Authorization: SharedKey $STORAGE_ACCOUNT:$SIGN_PUT" \
          -H "Content-Length:0" \
          "https://$STORAGE_ACCOUNT.file.core.windows.net/$SHARE_OR_DIR_NAME?restype=$TYPE"

        echo "Created File Share $SHARE_OR_DIR_NAME"

        shift
done