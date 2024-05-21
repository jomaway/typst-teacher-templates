set quiet

# set aliases
self := justfile_directory()


[private]
default:
	just --list


pack package target:
	./scripts/pack.py "{{package}}" "{{target}}"
