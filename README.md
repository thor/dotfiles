thor's `dotfiles`
===============

*Messy dot-files for a messy user*


Usage 
===============

```sh
$ git clone git@github.com:thor/dotfiles.git ~/.dotfiles
$ dotdrop install -c ~/.dotfiles/config.yaml
$ # the following is somewhat ironic
$ mkdir -p ~/.config/dotdrop
$ ln -s ~/.dotfiles/config.yaml ~/.config/dotdrop/
```


`~/.config`
-----------

*Here be dragons* -- Abraham Lincoln



`~/.local/bin` 
--------------

-	`set-volume.sh`\
	Increase, decrease and toggle mute of volume.

-	`i3-bars.sh`\
	It does nothing.

	[ ] Remove `i3-bars.sh`

-	`i3-lock`\
	Locks my screen in not-too-much-time.

-	`i3-lock-on-suspend.sh`\
	Locks my screen *on suspend*, which is neat. However, I have yet to fully
	understand how it works, but it's pretty cool. Lesson for later!

-	`mmonitors.sh`\
	Really what *should* be named `i3-bars.sh`. Simple, manual, and rarely
	changed monitor management.

-	`rofi-lpass`\
	Someone, somewhere, made a little thing for querying `lpass` via rofi.


