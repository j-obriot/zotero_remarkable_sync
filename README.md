currently syncs a zotero collection named "Doctorat" to a remarkable folder named "Zotero"

Notably, it doesn't require the tablet to have anything installed on it. It doesn't even require ssh access to the tablet. It works using the web interface provided by the tablet, which should be activated in general > storage > USB connection

should be POSIX compliant but needs:

- `jq` for json parsing
- `curl`
- `sqlite3` to read zotero database
