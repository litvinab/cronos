# cronos

Simple dockerized cron which can call other dockerized services

# Local CLI calls

Default crontab file (`./crontabs/root`) content:

`*/1 * * * * date "%d-%m-%y +%H:%M:%S" >> var/log/cron.log`

## Build & Run
```shell
# Build container
docker build --tag cronos . 

# Run it with volumes
docker run --name cron -d -v $(pwd)/crontabs:/etc/crontabs cronos
```

## Test
```shell
 # Enter container
docker exec -it cron sh

# Watch the real-time updates made after each cron launch 
# You can get an error during this call 
# It's OK, wait for the first cron launch
tail -F /var/log/cron.log 
```

# Other dockerized services CLI calls

It's good approach to use the cron as separated service without adding of not necessary complexity to the dockerized applications.

You need to setup the cron service in the docker compose file similar to this one down below:

```yml
version: '2'
services:
    your-service-name:
        ... 

    cron:
        container_name: cronos
        volumes:
            - "/var/run/docker.sock:/var/run/docker.sock" 
            # you can add /etc/crontabs volume also
        restart: always
```

Crontab record example to call other services:

`*/3 * * * * docker exec -t your-service-name sh -c '/var/www/app/bin/console ts:snapshots:get >> /var/log/cron.log'`

Example of the project can be found here: *TBD*