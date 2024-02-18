#!/usr/bin/env bash

set -o errexit
set -o pipefail

# shellcheck source=SCRIPTDIR/jehon/usr/bin/jh-lib
. jh-lib

[ -n "$1" ] || jh_fatal "Need the target as [1]"

TARGET="$1"
VERSION="${2:-no version}"
mkdir -p "$(dirname "$TARGET")"

jh_info "Building version $VERSION"
header_begin "Syncing files"
#
# We take:
#   - all in git
#
# We don't take:
#   - .built: build marker
#   - _* (unused files)
#

rsync -a \
	--exclude "tmp" \
	--exclude ".built" \
	--include ".git" --include ".git/**" \
	--exclude "🔒_*" \
	--exclude "[Rr]eadme*" \
	--delete --delete-excluded \
	packages/ "$TARGET"/
header_end

#
# Moving into target
#
(
	cd "$TARGET"

	install_script() {
		local PKG_NAME="$1"
		local SRC="$2"
		shift
		shift

		SRC_FILE="$PKG_NAME/debian${SRC}"
		if [ -r "$SRC_FILE" ]; then
			for var in "$@"; do
				DST_FILE="debian/${PKG_NAME}${var}"
				echo "Generate $DST_FILE"
				cat "$SRC_FILE" >"$DST_FILE"
			done
			rm -f "$SRC_FILE"
		fi
	}

	header_begin "Generate configuration files"
	for F in jehon*; do
		N="$(basename "$F")"
		echo "Configuring packages $N"
		(
			echo "Generate control for $N"
			(
				cat <<-EOT
					# ------------- $N ------------------
					Package: $N
					Architecture: all
					Pre-Depends: \${misc:Pre-Depends}
					Description: Jehon debian package
				EOT

				if [ ! -r "$N/debian.control" ]; then
					jh_fatal "Need a debian.control everywhere !"
				fi

				sed "s/JH_VERSION/${VERSION}/g" "$N/debian.control"
				rm -f "$N/debian.control"

				echo ""
				echo ""
				echo ""

			) >>debian/control

			install_script "$N" ".triggers" ".triggers"
			install_script "$N" ".scripts" ".postinst" ".prerm"
			install_script "$N" ".scripts-around" ".postrm" ".preinst"

			# Remove all empty folders
			find "$N"/ -type d -empty -delete 2>/dev/null

			# Generate .links
			(
				echo ""
				echo "# Syntax: <target> <link-name>"
				echo ""

				if [ -r "$N/debian.links" ]; then
					jh_pipe_message "Generate links (manual)"
					echo "#"
					echo "# Manually added:"
					echo "#"
					cat "$N/debian.links"
					echo ""
					rm -f "$N/debian.links"
				fi
				if [ -d "$N/usr/share/$N/etc" ]; then
					jh_pipe_message "Generate links (automatic)"
					echo ""
					echo "#"
					echo "# Automatically added:"
					echo "#"
					(cd "$N/usr/share/$N/etc" && find . -type "f,l" -printf "/usr/share/$N/etc/%P /etc/%P\n" 2>/dev/null)
					# -exec "echo" "/usr/share/$N/etc/{} /etc/{}" ";")
				fi
			) >"debian/$N.links"

			# Generate the list of files to install
			#   need to come after cleanup
			(
				if [ -r "$N/debian.install" ]; then
					jh_pipe_message "Generate install (manual)"
					echo "#"
					echo "# Manually added:"
					echo "#"
					cat "$N/debian.install"
					echo ""
					rm -f "$N/debian.install"
				fi

				if jh-fs not-empty "$N" ; then
					jh_pipe_message "Generate install (automatic)"
					echo ""
					echo "#"
					echo "# Automatically added:"
					echo "#"
					echo "${N}/* /"
				fi
			) >"debian/${N}.install"

			if [ -n "$(find "$N" -mindepth 1 -maxdepth 1 -type f 2>/dev/null)" ]; then
				jh_fatal "You have too much control files in $N"
			fi
		) 3>&1 | sed -e "s%^%  - %"
	done
	header_end

	# header_begin "Generate changelog"
	# # https://www.debian.org/doc/manuals/maint-guide/dreq.en.html#changelog
	# cat >debian/changelog <<-EOS
	# 	jehon-debs (2022.09.21.09.13.34.20220921123617) main; urgency=medium

	# 	  [ root ]
	# 	  * UNRELEASED

	# 	 -- Jean Honlet <jehon@users.noreply.github.com>  Wed, 21 Sep 2022 12:36:17 +0000

	# 	jehon-debs ($VERSION) main; urgency=medium

	# 	$(git log --pretty=format:"   * %h %s" --since 1.day)
	# 	 -- Jean Honlet <jehon@users.noreply.github.com> $(date)
	# EOS
	# header_end

	header_begin "Adding makefile"
	cp -f debian/Makefile Makefile
	header_end
)
