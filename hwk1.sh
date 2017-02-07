#!/bin/sh

#   This downloads all needed files, 
#   CMD: Downloads, count and disk usage in one line
#seq -f "%02g" 1 31 | parallel wget http://data.gdeltproject.org/events/201612{}.export.CSV.zip &>/dev/null ; ls -l *.zip | wc -l ; du -h .

#   Processing the downloaded files putting the right headers in database
#   CMD: Re-creates file names, in parallel unzip all files and search in Actor1CountryCode for /MEX/ and in EventCode for /MX/
#seq -f "%02g" 1 31 | parallel zcat 201612{}.export.CSV.zip | awk '( $8~/MEX/ || $27~/MX/)' | sed "s/[[:space:]]\+/\t/g" | \
#sed '1s/^/'"$(wget -nv -qO- http://gdeltproject.org/data/lookups/CSV.header.dailyupdates.txt | xargs -n1 | awk 'NR%58{printf "%s\t",$0;next}7')"'\n/gm' | \
#csvsql --db sqlite:///mexico.db --insert --tables mexico -t


seq -f "%02g" 1 31 | parallel zcat 201612{}.export.CSV.zip | awk '( $8~/MEX/ || $27~/MX/)' |\
sed '1s/^/'"$(wget -nv -qO- http://gdeltproject.org/data/lookups/CSV.header.dailyupdates.txt |\
xargs -n1 | awk 'NR%58{printf "%s\t",$0;next}7')"'\n/gm' | seq -f "%02g" 1 31 | parallel zcat 201612{}.export.CSV.zip |\
awk '( $8~/MEX/ || $27~/MX/)' | sed '1s/^/'"$(wget -nv -qO- http://gdeltproject.org/data/lookups/CSV.header.dailyupdates.txt |\
xargs -n1 | awk 'NR%58{printf "%s\t",$0;next}7')"'\n/gm' |\
tee >(awk -F $'\t' '{ a[$57]++; b[$57]=$31} END { for (i in a) print i, ","a[i], ","b[i]| "sort -nk 1"}'| csvsql --db sqlite:///mexico.db --insert --tables mexico_ts -t ) |\
csvsql --db sqlite:///mexico.db --insert --tables mexico -t 

