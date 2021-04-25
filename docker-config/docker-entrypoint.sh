#!/bin/sh
app=${DOCKER_APP:-app}

if [ "$app" = "app" ]; then

    echo "Running the app..."
    ## Run Optimization
    /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf

elif [ "$app" = "queue" ]; then

    echo "Running the queue..."
    php /var/www/html/artisan queue:work --queue=default --sleep=3 --tries=3 --timeout=90

elif [ "$app" = "scheduler" ]; then

    echo "Running the scheduler..."
    while [ true ]
    do
        php /var/www/html/artisan scheduler:run --no-interaction &
        sleep 60
    done

else
    echo "Could not match the container app \"$app\""
    exit 1
fi
