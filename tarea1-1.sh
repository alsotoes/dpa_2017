#!/bin/sh

http http://swapi.co/api/films/ | jq '.results[] | (.title, .episode_id, .director, .producer, .release_date, .opening_crawl) ' | sed "s/,/ -/g" | awk 'NR%6{printf "%s,",$0;next}7' | sed '1s/^/title,episode_id,director,producer,release_date,opening_crawl\n/gm' | csvsql --db sqlite:///star_wars.db --insert --tables films_t1
