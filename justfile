set quiet

# set aliases
self := justfile_directory()


[private]
default:
	just --list
