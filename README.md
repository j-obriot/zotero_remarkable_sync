currently syncs a zotero collection named "Doctorat" to a remarkable folder named "Zotero".

The motivation behind this is to have an easy way to send all the new papers in a zotero collection to the remarkable without passing by their "cloud" (fuck it).

Notably, it doesn't require the tablet to have anything installed on it. It doesn't even require ssh access to the tablet or it to be connected to an remarkable account. It works using the web interface provided by the tablet, which should be activated in general > storage > USB connection.

Files can be renamed afterward, but should keep the 8-characters identifying string at the end of the name (or just before .pdf).

For now it's only one way, Zotero -> Remarkable. But with a few modification it should be simple to do the inverse.

I don't know if item keys are preserved between synced zotero libraries...

should be POSIX compliant but needs:

- `jq` for json parsing
- `curl`
- `sqlite3` to read zotero database

## run
```sh
$ ./sync.sh
```

running it multiple times should only send new files.
