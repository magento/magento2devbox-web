#!/bin/bash

if [[ $USE_SHARED_WEBROOT == "0" ]]
then
    # if using custom sources
    if [[ "$(ls -A /home/magento2/magento2)" ]] && [[ ! "$(ls -A /var/www/magento2)" ]]
    then
        echo "[IN PROGRESS] Sync Started." > /var/www/magento2/status.html
        sed -i 's/^\(\s*DirectoryIndex\s*\).*$/\1status.html/' /home/magento2/magento2/.htaccess
        cp /home/magento2/magento2/.htaccess /var/www/magento2/
        chown magento2:magento2 /var/www/magento2/.htaccess
        service apache2 start

        if [[ $CREATE_SYMLINK_EE == "1" ]]
        then
            mkdir -p "$HOST_CE_PATH"
            ln -s "/var/www/magento2/$EE_DIRNAME" "$HOST_CE_PATH/$EE_DIRNAME"
        fi

        echo "[IN PROGRESS] Unison sync started" > /var/www/magento2/status.html

        (su - magento2 -c 'unison magento2') || (su - magento2 -c 'unison magento2')

        chmod +x /var/www/magento2/bin/magento

        echo "[DONE] Sync Finished" > /var/www/magento2/status.html
        sed -i 's/^\(\s*DirectoryIndex\s*\).*$/\1index.php/' /home/magento2/magento2/.htaccess
        sed -i 's/^\(\s*DirectoryIndex\s*\).*$/\1index.php/' /var/www/magento2/.htaccess
        rm -f /var/www/magento2/status.html
        rm -f /home/magento2/magento2/status.html

        su - magento2 -c 'unison -repeat=watch magento2' &
    else
        (
            (su - magento2 -c 'unison magento2') || (su - magento2 -c 'unison magento2')
            (su - magento2 -c 'unison -repeat=watch magento2')
        ) &
    fi
fi

supervisord -n -c /etc/supervisord.conf
