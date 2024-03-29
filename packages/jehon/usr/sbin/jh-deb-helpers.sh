#!/usr/bin/env sh

DEB_CMD="$1"

#
# See https://www.debian.org/doc/debian-policy/ch-maintainerscripts
#
# file                  | off file | command [1]       | alternate commands
#-----------------------+----------+-------------------+----------------------------
# debian.scripts-around | preinst  | install|upgrade   | abort-upgrade
# debian.scripts        | postinst | configure         | abort-upgrade|abort-remove|abort-deconfigure
# debian.scripts        | prerm    | remove            | upgrade|deconfigure|failed-upgrade
# debian.scripts-around | postrm   | remove            | upgrade|failed-upgrade|abort-install|abort-upgrade
#    cont'              |   cont'  | purge             |
#
#
#
### debian.script
#
# case "$1" in
# configure) ;;
# # !! Does not work as expected
# triggered) ;;
# remove) ;;
# esac
#
#
### debian.scripts-around
#
# case "$1" in
# install | upgrade) ;;
# remove) ;;
# purge ) ;;
# esac
#

. /usr/share/debconf/confmodule

# jh_deb_helper_move() {
# 	FROM="$1"
# 	TO="$2"

# 	case "$DEB_CMD" in
# 	"configure")
# 		if [ -r "$FROM" ]; then
# 			rm -f "$TO"
# 			mv "$FROM" "$TO"
# 		fi
# 		;;
# 	"remove")
# 		if [ -r "$TO" ]; then
# 			rm -f "$FROM"
# 			mv "$TO" "$FROM"
# 		fi
# 		;;
# 	esac
# }

jh_deb_helper_patch() {
	TARGET="$1"
	TAG="$2"
	PATCH="$3"

	case "$DEB_CMD" in
	"configure")
		/usr/bin/jh-patch "$TARGET" "$TAG" "$PATCH"
		;;
	"remove")
		/usr/bin/jh-patch "$TARGET" "$TAG"
		;;
	esac
}

jh_deb_helper_system_group() {
	GRP="$1"

	case "$DEB_CMD" in
	"configure")
		if ! getent group "$GRP" >/dev/null; then
			echo "* Adding group $GRP"
			groupadd -r "$GRP"
		fi
		;;
	"remove")
		# Nothing: it is dangerous to remove it
		# groupdel -f "$GRP" 2>/dev/null || true
		;;
	esac
}

jh_deb_helper_system_user() {
	N_USER="$1"

	case "$DEB_CMD" in
	"configure")
		if ! id "$N_USER" 1>/dev/null 2>/dev/null; then
			# Initial configuration
			echo "* Creating user $N_USER (locked)"
			useradd --create-home --shell /bin/bash --system "$N_USER" >/dev/null
			passwd -l "$N_USER"
		fi

		;;
	"remove")
		# Nothing: it is dangerous to remove it
		# if ! id "$N_USER" 1>/dev/null 2>/dev/null; then
		# 	deluser --remove-home "$N_USER" 2>/dev/null || true
		# fi
		;;
	esac
}

jh_deb_helper_user_in_group() {
	USR="$1"
	GRP="$2"

	case "$DEB_CMD" in
	"configure")
		if ! id -nG "$USR" | grep -qw "$GRP" >/dev/null 2>/dev/null; then
			usermod -a -G "$GRP" "$USR"
		fi
		;;
	"remove")
		# Nothing: it is dangerous to remove it
		# groupdel "$GRP" 2>/dev/null|| true
		;;
	esac
}

jh_deb_helper_git_repo() {
	REPO_NAME="$1"
	REPO_URL="$2"
	REPO_FOLDER="/opt/jehon/$REPO_NAME"

	case "$DEB_CMD" in
	"configure")
		if [ ! -d "$REPO_FOLDER/.git" ]; then
			echo "Initializing $REPO_FOLDER"
			git clone --quiet --depth=1 --recurse-submodules "$REPO_URL" "$REPO_FOLDER"
		fi
		/usr/bin/jh-repository-update "$REPO_FOLDER" >/dev/null
		;;
	"remove")
		rm -fr "$REPO_FOLDER" 2>/dev/null || true
		;;
	esac
}

jh_deb_helper_python() {
	# /usr/lib/python3/dist-packages/jehon/requirements.txt
	REQUIREMENTS="$1"

	# /var/lib/python/jehon
	TARGET="$2"

	case "$DEB_CMD" in
	"configure")
		if ! cmp --silent "$REQUIREMENTS" "$TARGET"/requirements.txt 2>/dev/null \
			|| [ "$( cat "$TARGET"/python-version )" != "$( python3 --version )" ]; then
			rm -fr "$TARGET"
			mkdir -p "$TARGET"
    		python3 -m pip install -r "$REQUIREMENTS" --target "$TARGET" --upgrade
			cp "$REQUIREMENTS" "$TARGET"/requirements.txt
			python3 --version > "$TARGET"/python-version
		fi
		;;
	"remove")
		rm -fr "$TARGET"
		;;
	esac
}

jh_deb_helper_service() {
	SERVICE="$1"

	if jh-is-full-machine >/dev/null; then
		case "$DEB_CMD" in
		"configure")
			systemctl daemon-reload
			systemctl enable "${SERVICE}"
			systemctl reload-or-restart "${SERVICE}" || (
				echo "Service ${SERVICE} failed to start, but let's continue installation anyway" >&2
			)
			;;
		"remove")
			systemctl daemon-reload || true
			systemctl disable --all "$SERVICE" || true
			systemctl stop --all "$SERVICE" || true
			;;
		esac
	fi
}

jh_deb_helper_cloud_mount() {
	MOUNT="$1"
	jh_deb_helper_service "${MOUNT}.mount"
}

jh_deb_helper_ufw() {
	TYPE="$1" # port / app
	SERVICE="$2"
	NETWORK_NAME="$3"

	# # Wait for xtable lock to be available
	# /sbin/iptables -L -n --wait >/dev/null

	case "$NETWORK_NAME" in
	"public")
		NETWORKS="any"
		;;
	"home")
		# Autoconfigured ipv6 network
		NETWORKS="fe80::0/64"
		;;
	"homeIPv4")
		NETWORKS="192.168.0.0/16"
		;;
	*)
		echo "jh_deb_helper_ufw need a network explicitely [3]: public / hyperv / home" >&2
		exit 1
		;;
	esac

	if jh-is-full-machine >/dev/null; then
		case "$DEB_CMD" in
		"configure")
			ufw allow from "$NETWORKS" to any "$TYPE" "$SERVICE"
			;;
		"remove")
			ufw delete allow from "$NETWORKS" to any "$TYPE" "$SERVICE" 2>/dev/null || true
			;;
		esac
	fi
}

jh_deb_helper_snap() {
	NAME="$1"

	if jh-is-full-machine >/dev/null; then
		case "$DEB_CMD" in
		"configure")
			/usr/bin/jh-snap-ensure-installed "$@"
			;;
		"remove")
			snap remove "$NAME" 2>/dev/null || true
			;;
		esac
	fi
}

jh_deb_helper_snap_config() {
	SNAP="$1"
	KEY="$2"
	EXPECTED="$3"

	if jh-is-full-machine >/dev/null; then
		case "$DEB_CMD" in
		"configure")
			CURRENT="$(snap get "$SNAP" "$KEY" 2>/dev/null)"
			if [ "$CURRENT" != "$EXPECTED" ]; then
				snap set "$SNAP" "$KEY=$EXPECTED"
				sleep 3s
			fi
			;;
		"remove")
			# Nothing to do
			true
			;;
		esac
	fi
}

jh_deb_helper_invert() {
	case "$DEB_CMD" in
		"configure")
			DEB_CMD="remove" "$@"
			;;
		"remove")
			DEB_CMD="configure" "$@"
			;;
	esac
}

jh_deb_helper_legacy() {
	# Simulate the "remove" call
	DEB_CMD="remove" "$@"
}
