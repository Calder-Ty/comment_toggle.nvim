# comment_toggle.nvim

Vim Plugin for quick togling of comments. Adds command `:CommentToggle`, which detects the presence
of comments and turns them on or off. Works with visual selection for commenting whole lines.


Currently comments are defined for the following filetypes:

- ada
- apl
- c
- conf
- cpp
- cs
- Dockerfile
- freebasic
- fstab
- gitcommit
- go
- haskell
- java
- javascript
- lua
- mail
- nim
- odin
- perl
- php
- python
- r
- ruby
- rust
- scala
- sh
- sql
- tex
- todotext
- typescript
- vim
- yaml
- yml

PR's are welcome to add new filetypes. If you don't want to do that you can set
the variable `comment_toggle_comment_leader` in your buffer.
