set quiet

# set aliases
self := justfile_directory()
typst-dir := "~/.local/share/typst/packages/local/"


[private]
default:
	just --list

install:
	just install-utils
	just install-exam

# install exam template
install-exam:
	echo "Create folder {{typst-dir}}/ttt-exam"
	mkdir {{typst-dir}}/ttt-exam
	echo "Install ttt-exam by creating a symlink to the local git repo."
	ln -s {{self}}/ttt-exam {{typst-dir}}/ttt-exam/0.1.0

# install exam template
install-utils:
	mkdir {{typst-dir}}/ttt-utils
	ln -s {{self}}/ttt-utils {{typst-dir}}/ttt-utils/0.1.0

# install exam template
install-lists:
	echo "Create folder {{typst-dir}}/ttt-lists"
	mkdir {{typst-dir}}/ttt-lists
	echo "Install ttt-lists by creating a symlink to the local git repo."
	ln -s {{self}}/ttt-lists {{typst-dir}}/ttt-lists/0.1.0
