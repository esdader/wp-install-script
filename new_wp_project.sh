#! /bin/bash

clear

read -p "Start new WordPress project? (y/n) " RESP

if [ "$RESP" = "y" ]; then

    echo -e "Starting new WordPress project . . .\n"
    wp core download
    echo -e "\n\n"
    read -p "Do you need to create a database? (y/n) " RESP
    read -p "Enter database name: " DBNAME
    read -p "Enter database user: " DBUSER
    read -p "Enter database host: " DBHOST
    read -s -p "Enter database password: " DBPASSWORD 
    if [ "$RESP" = "y" ]; then
        mysqladmin -u"$DBUSER" -p"$DBPASSWORD" create "$DBNAME"
    fi
    echo -e "\n\nCreating config . . .\n"
    wp core config --dbname="$DBNAME" --dbuser="$DBUSER" --dbhost="$DBHOST" --dbpass="$DBPASSWORD"
    
    read -p "Enter url: " EARL
    read -p "Enter site title: " SITE_TITLE
    read -p "Enter admin username: " USERNAME
    read -p "Enter admin email: " ADMIN_EMAIL
    read -s -p "Enter admin password: " ADMIN_PASSWORD
    echo -e "\n\nInstalling WordPress . . .\n"
    wp core install --url="$EARL" --title="$SITE_TITLE" --admin_user="$USERNAME" --admin_password="$ADMIN_PASSWORD" --admin_email="$ADMIN_EMAIL"
    
    echo -e "\n\nStart installing plugins . . .\n"
    read -p "Install Advanced Custom Fields? (y/n) " RESP

    if [ "$RESP" = "y" ]; then
        echo -e "Installing Advanced Custom Fields . . .\n"
        wp plugin install "/Users/tristanader/Dropbox/plugins/wordpress plugins/advanced-custom-fields-pro.zip"
        wp plugin activate "advanced-custom-fields-pro"
    fi

    read -p "Install Custom Post UI? (y/n) " RESP

    if [ "$RESP" = "y" ]; then
        echo -e "Installing Custom Post UI. . .\n"
        wp plugin install "custom-post-type-ui"
        wp plugin activate "custom-post-type-ui"
    fi

    read -p "Install WP Migrate Pro? (y/n) " RESP

    if [ "$RESP" = "y" ]; then
        echo -e "Installing WP Migrate Pro. . .\n"
        wp plugin install "/Users/tristanader/Dropbox/plugins/wordpress plugins/wp-migrate-db-pro.zip" 
        wp plugin activate "wp-migrate-db-pro"
    fi

    echo -e "\n\nDone installing plugins. Install starter theme next\n"
    read -p "Install Starter Theme? (y/n) " RESP

    if [ "$RESP" = "y" ]; then
        read -p "What do you want to call this theme? " THEME_NAME
        echo -e "\nInstalling Starter theme. . .\n"
        cd "wp-content/themes"
        git clone https://github.com/esdader/petulant-octo-wight.git "$THEME_NAME"
        cd "$THEME_NAME"
        rm "./README.md"
        sed "s/Starter\ Theme/$THEME_NAME/" style.css > tmp.css ; mv tmp.css style.css
        rm -rf "./git"
        git init
        git add .
        git commit -m "initial commit"
        wp theme install "$THEME_NAME" --activate

    fi
   echo -e "\n\n. . . All done installing new WordPress site." 
else 
    echo -e "Exiting script . . .\n\n"
fi 
