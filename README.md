# bm
Simple bookmark tool for navigating the file system

`bm` is a tiny CLI utility that lets you create **named shortcuts** to the
directories you work with most often.  
Instead of typing long `cd /some/really/long/path/to/project`, you can jump
there instantly:
```bash
# add a bookmark called "proj"
bm -s proj

# later, anywhere in your shell:
bm proj   # → switches to /some/really/long/path/to/project
```
---

## Features

* Add, remove and list directory bookmarks.
* Bookmarks are stored as plain JSON under `~/.config/bm/bookmarks.json`
  (cross-platform location resolved with the `dirs` crate).
