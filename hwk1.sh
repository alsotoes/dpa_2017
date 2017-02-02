# This downloads all files needed
seq -f "%02g" 1 31 | parallel -j31 wget http://data.gdeltproject.org/events/201612{}.export.CSV.zip &>/dev/null ; ls -l *.zip | wc -l ; du -h .

#zcat 20170128.export.CSV.zip | awk '{if ($27 ~ /MX/) print}' | sed 's/\t+/ \t/p' | csvsql --db sqlite:///gdelt.db --insert --table mexico -t
#zcat 20170128.export.CSV.zip | awk '{if ($27 ~ /MX/) print}' | head -1 | sed "s/[[:space:]]\+/\t/g"

zcat 20161201.export.CSV.zip | awk '{if ($27 ~ /MX/) print}' | sed "s/\t\+\t/g" | csvsql --db sqlite:///gdelt.db --insert --tables mexico -t -H
