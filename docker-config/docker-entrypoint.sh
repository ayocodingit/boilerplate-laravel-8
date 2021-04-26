#!/bin/sh

app=${DOCKER_APP:-app}
worker=${OCTANE_WORKER:-1}

if [ "$app" = "app" ]; then

    echo "Running the app..."
    /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf

elif [ "$app" = "queue" ]; then

    echo "Running the queue..."
    php /var/www/html/artisan queue:work --queue=default --sleep=3 --tries=3 --timeout=90

elif [ "$app" = "octane" ]; then

    echo "Running the app with octane count worker $worker..."
    php /var/www/html/artisan octane:start --host=0.0.0.0 --port=8080 --workers=$worker -n

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
