default: updates

updates: preflight
	# vim -c 'call UpdateEverything() | qa' || true
	nvim -c 'call UpdateEverything() | qa' || true
	brew upgrade
	brew upgrade --cask
	brew cleanup || true
	brew doctor || true
	npm install -g npm
	npm update -g
	# sudo softwareupdate --install --all --restart
	sudo softwareupdate --install --all
