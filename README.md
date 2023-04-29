# cronos

Simple dockerized cron to call other dockerized services

## Call commands inside the cronos container

Default crontab file (`./crontabs/root`) content:

`*/1 * * * * date "%d-%m-%y +%H:%M:%S" >> var/log/cron.log`

### Build & Run
```shell
# Build container
docker build --tag cronos . 

# Run it with volumes
docker run --name cron -d -v $(pwd)/crontabs:/etc/crontabs cronos
```

### Test
```shell
 # Enter container
docker exec -it cron sh

# Watch the real-time updates made after each cron launch 
# You can get an error during this call. It's OK, wait for the first cron launch
tail -F /var/log/cron.log 
```

## Call other dockerized services using cronos

It's good approach to use the cron as separated service without adding of not necessary complexity to the dockerized applications.

You need to setup the cron service in the docker compose file similar to this one down below.

The main thing in this configuration is to use `/var/run/docker.sock` volume for the `cronos`-based service.

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

`*/1 * * * * docker exec -t your-service-name sh any-cli-command.sh`

Pay attention:
- crontab file should have the `root` name to make it work (it's placed under the `./docker/cronos/crontabs` folder in the example above);
- `sh any-cli-command.sh`command should work inside the `app` container; Permissions error can be found;
- `docker exec -t your-service-name sh any-cli-command.sh` command should work during the direct call at docker-hosted machine;

Example of the project setup can be found here: 
[litvinab/cronos-example](https://github.com/litvinab/cronos-example)