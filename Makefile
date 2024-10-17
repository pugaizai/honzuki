.PHONY: watch
watch:
	dart run build_runner watch --delete-conflicting-outputs

.PHONY: build
build:
	dart run build_runner build

.PHONY: fix
fix: 
	dart fix --apply
	dart format .

.PHONY: gen-l10n
gen-l10n:
	flutter gen-l10n

.PHONY: launcher-icons
launcher-icons:
	dart run flutter_launcher_icons
