#!/usr/bin/bash
#
# publish.sh - Publish a new gem version
#

trap _error_handler ERR
function _error_handler() {
	echo -ne "\e[1;31m=> Previous command exited unsuccessfully. Abort (y/n)? \e[0m"
	read -n 1 VAR
	echo

	[[ "${VAR}" != 'n' ]] && { echo "Aborting."; exit 1; }
}

VERSION="$1"
if [[ ! "$1" ]]; then
	echo -ne "Previous version: `git describe --abbrev=0 --tags | sed -e 's/v//g'`. New version: "
	read VERSION
	echo
fi

# Release commit and tag
git reset HEAD
sed -s "s/VERSION = .*$/VERSION = '${VERSION}'/" -i lib/metal_archives/version.rb
git add lib/metal_archives/version.rb
git commit -m "Release version v${VERSION}"
git tag "v${VERSION}"
git push
git push --tags

# Gem
gem build metal_archives.gemspec
gem push "metal_archives-${VERSION}.gem"
rm -rf html/
rake rdoc
tar cvjf "metal_archives-${VERSION}-doc.tar.gz" html/

# Documentation
git add --all .
git stash
git checkout gh-pages
git reset --hard 'HEAD^'
git merge master
rm -rf html/
rake rdoc
git add -f html/
git commit -m 'Add documentation'
git push --force
git checkout master
git stash pop
git reset HEAD
