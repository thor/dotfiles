thor's `dotfiles` ⚙
===================

>*Messy dotfiles for a messy user*

These dotfiles are managed using [rcm][rcm], but may also be managed using
[YADM][yadm], or even in part using [GNU stow][stow] if you want to stick to that.


Usage 
===============

I recommend that you *either* cherry-pick or fork the repository as a whole.

```sh
$ git clone git@github.com:thor/dotfiles.git ~/.dotfiles
$ rcup -d ~/.dotfiles
```


`~/.config`
-----------

>*Here be dragons*  
>-- Abraham Lincoln

`~/.local/bin` 
--------------

-	`set-volume.sh`\
	Increase, decrease and toggle mute of volume.

-	`i3-lock`\
	Locks my screen in not-too-much-time, but also reduces DPMS.

-	`i3-lock-on-suspend.sh`\
	Locks my screen *on suspend*, which is neat. However, I have yet to fully
	understand how it works, but it's pretty cool. Lesson for later!

-	`mmonitors.sh`\
	Really what *should* be named `i3-bars.sh`. Simple, manual, and rarely
	changed monitor management.

-	`rofi-lpass`\
	Someone, somewhere, made a little thing for querying `lpass` via rofi.


