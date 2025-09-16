et-alley() {
    if [ $# -lt 8 ]; then
        echo "Usage: $0 \"YYYY:MM:DD HH:MM:SS\" \"Set#27\" \"<ARTIST_NAME>\" \"<STUDIO_ID>\" \"Gallery Title\" \"DL-Source URL\" \"Forum Post URL\" \"<PIC_INFO>\""
        echo
        echo "Example:"
        echo "et-alley \"2017:07:07 22:00:00\" \"Set#27\" \"Carolina Fong\" \"theblackalley.com\" \"The Black Alley\" \\
                \"https://xfobo.com/showthread.php?t=2412481&p=32338591#post32338591\" \\
                \"https://forum.intporn.com/threads/the-black-alley-update-since-2016-01-01.733193/post-47319037\" \"[116 pics in 2000 res. 90MB]\""
    else
        EXIF_DATE="$1"
        SET_NAME="$2"
        ARTIST="$3"
        STUDIO_ID="$4"
        STUDIO_LABEL="$5"
        DL_SOURCE="$6"
        FORUM_POST="$7"
        PIC_INFO="$8"

        # Format EXIF_DATE into YYYYMMDD
        DATE_TAG=$(echo "$EXIF_DATE" | awk -F'[ :]' '{print $1$2$3}')
        DATE_DOT=$(echo "$EXIF_DATE" | awk -F'[ :]' '{print $1"."$2"."$3}')
        SET_NAME_DOT=$(echo "$SET_NAME" | sed 's/#/./g')
        USERCOMMENT=$(echo "[TBA] $DATE_TAG $ARTIST - $SET_NAME")
        FILETOUCH_DATE=$(echo "$EXIF_DATE" | awk -F'[ :]' '{print $1"-"$2"-"$3" "$4":"$5":"$6}')

        clear;
        cat <<EOF
        exiftool-clr -AllDates="$EXIF_DATE" -overwrite_original -r ./*.jpg
        exiftool '-AllDates+<0:0:\$filesequence' "-usercomment=$USERCOMMENT" -XPKeywords="$ARTIST" -artist="$ARTIST" -copyright="$STUDIO_ID" -fileOrder -FileName -overwrite_original -r ./*.jpg
        files=(\`ls ./*.jpg\`); initepoch=\$(date -d "$FILETOUCH_DATE" +%s); start_index=0; for ((i=\${#files[@]}-1; i>=0; i--)); do currepoch=\$((initepoch+(start_index++))); initdt=\$(date --date='@'\$currepoch +%Y%m%d%H%M.%S); echo "touch \${files[\$i]}, with \$initdt"; touch -a -m -t \$initdt "\${files[\$i]}"; done
        ==============================

        [${DATE_TAG}-TBA] $ARTIST - $SET_NAME.PHOTOSET-ONLY.txt
        ==============================

        [$STUDIO_LABEL] $ARTIST $SET_NAME_DOT $DATE_DOT
        ********************

        [DL-Source] $DL_SOURCE
        $FORUM_POST     $PIC_INFO
EOF
    fi
}