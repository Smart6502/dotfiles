#!/bin/bash
# depends: ytdl, mpv, sxiv

flushch="true"
guicmd="sxiv -btio"
if [ -z "$*" ]; then 
	echo -n "Search: "
	read -r query
else
	query="$*"
fi
if [ -z "$query" ]; then exit; fi 
# sanitise the query
query=$(sed \
	-e 's|+|%2B|g'\
	-e 's|#|%23|g'\
	-e 's|&|%26|g'\
	-e 's| |+|g'\
	<<< "$query")

response="$(curl -s "https://www.youtube.com/results?search_query=$query" |\
	sed 's|\\.||g')"
if ! grep -q "script" <<< "$response"; then echo "unable to fetch yt"; exit 1; fi
vgrep='"videoRenderer":{"videoId":"\K.{11}".+?"text":".+?[^\\](?=")'
pgrep='"playlistRenderer":{"playlistId":"\K.{34}?","title":{"simpleText":".+?[^\"](?=")'
getresults() {
	  grep -oP "$1" <<< "$response" |\
		awk -F\" -v p="$2" '{ print $1 "\t" p " " $NF}'
}
videoids=$(getresults "$vgrep")
playlistids=$(getresults "$pgrep" "(playlist)")
[ -n "$playlistids" ] && ids="$playlistids\n"
[ -n "$videoids" ] && ids="$ids$videoids"
videolink="https://youtube.com/watch?v="
playlink="https://youtube.com/playlist?list="
cachedir="/home/$USER/.local/bin/.yt-img-cache"
[ -d $cachedir ] || mkdir -p $cachedir
[ $flushch == "true" ] && rm $cachedir/*jpg && echo "Cache was flushed successfully" || echo "Cache wasn't flushed: man"

gthumb() {
	local id=$1
	local imgurl=https://img.youtube.com/vi/$id/0.jpg
	[ -f $id.jpg ] || curl -s $imgurl -o $cachedir/$id.jpg
	echo "Thumbnail received - $id.jpg"
}
echo -e "$ids" >> $cachedir/.cheterm
alids=

# cat $cachedir/.cheterm
cat $cachedir/.cheterm | while read resline || [[ -n $resline ]];
do
	tmpid="$(printf "${resline:0:11}") "
	printf "$tmpid" >> $cachedir/.chid
done
rm $cachedir/.cheterm

clear
echo "Fetching thumbnails..."
for videoid in $(cat $cachedir/.chid)
do
	gthumb $videoid
done

echo "Flushing recvch..."
rm $cachedir/.chid

echo -e "\nm to mark a video and q to exit selector and start playing it\n\n"

while true; do
	while ! [ -z $(pidof mpv) ]; do sleep 5; done
	echo "Choose to play: "
	[ -z $(pidof mpv) ] && id=$(ls $cachedir/*jpg | $guicmd)
	id=${id:(-15)}
	id=${id:0:(-4)}	
	case $id in
		# 11 digit id = video
		???????????) mpv "$videolink$id" & disown  ;;
		# 34 digit id = playlist
		??????????????????????????????????) mpv "$playlink$id" & disown ;;
		*) exit ;;
	esac
done


