#!/bin/bash

for i in $(http http://swapi.co/api/ | jq 'keys[] as $k | "\($k)"' | sed "s/\"//g"); do \
URL="http://swapi.co/api/"${i}"/"?page=1 ;\
while [ 1 ]; do \
if [ "${URL}" == "null" ]; then break ; fi ; \
http ${URL} | jq '[.results[]]' | sed "s/^\[//1" | sed "s/\]$//1" >> ${i}.json ; \
URL=$(http ${URL} | jq '.next ' | sed "s/\"//g") ; \
if [ "${URL}" != "null" ]; then echo "," >> ${i}.json; fi ; \
done ; \
cat ${i}.json | sed '1 i\\[' | sed "\$a\]" | in2csv -f json -v | csvsql --db sqlite:///star_wars.db --insert --tables ${i} \
; done
