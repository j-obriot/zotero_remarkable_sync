#!/bin/sh

send() {
	echo "sending file: $2"
	echo "as: $1"
	curl -F"file=@\"$2\";filename=\"$1\"" http://10.11.99.1/upload
}

a=$(curl http://10.11.99.1/documents/ | jq -r '.[] | select(.Type=="CollectionType" and .VissibleName=="Zotero") | .ID')

if [ -z "$a" ]; then
	echo "No collection named Zotero found in remarkable device, aborting."
	exit 1
fi

fls=$(curl http://10.11.99.1/documents/$a | jq -r '.[] | .VissibleName')


ZOTERO="$HOME/Zotero"

a=$(sqlite3 -readonly -tabs "file:$ZOTERO/zotero.sqlite?immutable=1" "
SELECT a.itemID, a.key, f.path, v.value, v2.value, p.firstName, p.lastName
from itemAttachments f
inner join items a on a.itemID = f.itemID
inner join itemData d on f.parentItemID = d.itemID
inner join itemDataValues v on d.valueID = v.valueID
inner join itemData d2 on f.parentItemID = d2.itemID
inner join itemDataValues v2 on d2.valueID = v2.valueID
inner join itemCreators u on f.parentItemID = u.itemID
inner join creators p on u.creatorID = p.creatorID
inner join collectionItems i on f.parentItemID = i.itemID
inner join collections c on i.collectionID = c.collectionID
WHERE f.contentType = 'application/pdf'
AND d.fieldID = 1
AND d2.fieldID = 6
AND f.linkMode = 1
AND u.orderIndex = 0
AND c.collectionName = 'Doctorat';
")

IFS="

"

for i in $a; do
	IFS="	"
	echo "------------"
	key=""
	title=""
	dat=""
	firstname=""
	lastname=""
	f="$ZOTERO/storage"
	count=0
	for t in $i; do
		case $count in
			1)
				f="$f/$t"
				key="$t"
				;;
			2)
				f="$f/${t#storage:}"
				;;
			3)
				title="$t"
				;;
			4)
				dat="$t"
				;;
			5)
				firstname="$t"
				;;
			6)
				lastname="$t"
				;;
		esac
		count=$((count + 1))
	done

	if [ ! -f "$f" ]; then
		echo "file doesn't exists !!!"
		echo "------------"
		continue
	fi
	to="$lastname et al. ${dat::4} ${title::100}_$key.pdf"
	# echo "$to"
	# echo "$key"
	# echo "$firstname" "$lastname"
	# echo "$lastname et al."
	# | iconv -c -t ASCII//TRANSLIT//IGNORE # to recode to ascii, not very good

	IFS="
	"

	sending=1
	for c in $fls; do
		crm="${c%.pdf}"
		k=$(( ${#crm} - 8 ))
		ki="${crm:$k:8}"
		if [ $ki = $key ]; then
			sending=0
		fi
	done

	if [ "$sending" = 1 ]; then
		send "$to" "$f"
	else
		echo "not sending"
	fi
	echo "------------"
done
