#!/usr/bin/sh
fd . $1 |\
sd '(?P<prefix>\/.*\/)?(?P<datetime>\d{8}T\d{6})(==(?P<sig>[a-z0-9=]+))?(--(?P<title>[a-z0-9-]+))(__(?P<tags>[a-z0-9_]+))?(?P<ext>\.\w+)' '$prefix|$datetime|$sig|$title|$tags|$ext' |\
sd '[\=\-\_]' ' ' |\
sd '(\d{4})(\d{2})(\d{2})(T\d{6})' '$1-$2-$3|$4' |\
sd '\|\|' '|.|'|\
column -t -s "|" -N Prefix,Date,Time,Sig,Title,Tags,Ext |\
fzf --delimiter='\s{2,}' --nth=1..3 --with-nth=2,5,6 --header-lines=1 --reverse --info=hidden --no-separator --preview-window=bottom \
--preview='
sig={4}; sig=$(echo $sig | sd "\W" "" | sd " " "="); if [ ! -z ${sig} ] ;then sig="==${sig}"; fi; \
title={5}; title=$(echo $title | sd " " "-"); if [ ! -z ${title} ] ;then title="--${title}"; fi; \
tags={6}; tags=$(echo $tags | sd " " "_" | sd "\." ""); if [ ! -z ${tags} ] ;then tags="__${tags}"; fi; \
ext={7}; \
echo {1}\|{2}\|{3}\|{4}\|{5}\|{6}\|{7} | sd "(?P<prefix>\/.*\/)?\|(?P<d1>\d\d\d\d)-(?P<d2>\d\d)-(?P<d3>\d\d)\|(?P<time>T\d\d\d\d\d\d)\|.*" "\$prefix\$d1\$d2\$d3\$time$sig$title$tags$ext" | xargs cat' \
--bind='enter:execute( \
sig={4}; sig=$(echo $sig | sd "\W" "" | sd " " "="); if [ ! -z ${sig} ] ;then sig="==${sig}"; fi; \
title={5}; title=$(echo $title | sd " " "-"); if [ ! -z ${title} ] ;then title="--${title}"; fi; \
tags={6}; tags=$(echo $tags | sd " " "_" | sd "\." ""); if [ ! -z ${tags} ] ;then tags="__${tags}"; fi; \
ext={7}; \
echo {1}\|{2}\|{3}\|{4}\|{5}\|{6}\|{7} | sd "(?P<prefix>\/.*\/)?\|(?P<d1>\d\d\d\d)-(?P<d2>\d\d)-(?P<d3>\d\d)\|(?P<time>T\d\d\d\d\d\d)\|.*" "\$prefix\$d1\$d2\$d3\$time$sig$title$tags$ext" | cat)+abort'
