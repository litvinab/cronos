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
# You can get an error during this call. It's OK, wait for the first cron launch
tail -F /var/log/cron.log 
```

# Other dockerized services CLI calls

It's good approach to use the cron as separated service without adding of not necessary complexity to the dockerized applications.

You need to setup the cron service in the docker compose file similar to this one down below:

The main thing in this configuration is to use `/var/run/docker.sock` volume for cronos-based service.

```yml
version: '2'
services:
    your-service-name:
        container_name: app
        # ... service definition goes there ...

    cron:
        container_name: cronos
        image: litvinab/cronos
        volumes:
          - "/var/run/docker.sock:/var/run/docker.sock"
          - "./docker/cronos/crontabs:/etc/crontabs"
        restart: always
```

Crontab record example to call other services 
(`./docker/cronos/crontabs`content):

`*/1 * * * * docker exec -t your-service-name sh /shell/any-command.sh`

Pay attention:
- crontab file should have `./docker/cronos/crontabs/root` name to make it work;
- make sure that `/shell/any-command.sh`is working inside the `app` container; Permissions error can be found;
- make sure that `docker exec -t your-service-name sh /shell/any-command.sh` is working during the direct call at host machine;

Example of the project can be found here: 
[litvinab/cronos-example](https://github.com/litvinab/cronos-example)