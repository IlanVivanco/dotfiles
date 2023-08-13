dvb-create-host() {
	# Vars
	BASE_DIR="$HOME/www/$1/htdocs"
	DB_NAME="$1_db"
	DB_HOST="mysql"
	DB_USER="root"
	DB_PASS=""

	WP_URL="$1.local"
	WP_USER="ilan"
	WP_PASS="password"
	WP_EMAIL="ilanvivanco@gmail.com"
	WP_TITLE="$1 Dev"

	# Create dir
	mkdir -p $BASE_DIR
	cd $BASE_DIR

	# Download WP and install it
	wp core download --force --skip-plugins

	# Create config
	if [ ! -f "wp-config.php" ]; then
		wp config create --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASS --dbhost=$DB_HOST --skip-check
	fi

	# Create DB
	cd ~/.devilbox
	docker-compose exec --user devilbox php bash -c "mysql -u root -h 127.0.0.1 -e 'CREATE DATABASE IF NOT EXISTS $DB_NAME;'"

	# Install WP
	docker-compose exec --user devilbox php bash -c "cd $1/htdocs && \
    if ! wp core is-installed; then \
      wp core install \
      --url='$WP_URL' \
      --title='$WP_TITLE' \
      --admin_user='$WP_USER' \
      --admin_password='$WP_PASS' \
      --admin_email='$WP_EMAIL'; \
    fi"

	# add host
	echo "127.0.0.1 $WP_URL" >> /mnt/c/Windows/System32/drivers/etc/hosts

	# Go to the dir
	cd $BASE_DIR
}

dvb-remove-host() {
	# Vars
	BASE_DIR="$HOME/www/$1"
	DB_NAME="$1_db"
	DB_HOST="mysql"
	DB_USER="root"
	DB_PASS=""

	# Delete DB
	cd ~/.devilbox
	docker-compose exec --user devilbox php bash -c "mysql -u root -h 127.0.0.1 -e 'DROP DATABASE IF EXISTS $DB_NAME;'"

	# Remove dir
	rm -rf $BASE_DIR

	cd - > /dev/null
}

dvb-list-hosts() {
	find ~/www/ -maxdepth 1 -type d | awk -F '/' '$5{ print $5 }'
}

dvb-up() {
	cd ~/.devilbox
	docker-compose up -d bind httpd php mysql
	cd - > /dev/null
}

dvb-down() {
	cd ~/.devilbox
	docker-compose down
	cd - > /dev/null
}

dvb() {
	case $1 in
		list)
			dvb-list-hosts
			;;

		add)
			if [ -z "$2" ]; then
				echo "Error: you must supply a name to add as a second argument."
			else
				echo "Creating host $2..."
				dvb-create-host $2
				echo "Done!"
			fi
			;;

		remove)
			if [ -z "$2" ]; then
				echo "Error: you must supply a name to remove as a second argument."
			else
				echo "Removing host $2..."
				dvb-remove-host $2
				echo "Done!"
			fi
			;;

		up)
			echo "Starting Devilbox..."
			dvb-up
			echo "Done!"
			;;

		down)
			echo "Stopping Devilbox..."
			dvb-down
			echo "Done!"
			;;

		restart)
			echo "Stopping Devilbox..."
			dvb-down
			echo "Starting Devilbox..."
			dvb-up
			echo "Done!"
			;;

		*)
			echo "Available options are: remove, add, list, up, down or restart."
			;;
	esac
}
