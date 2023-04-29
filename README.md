# cronos

Simple dockerized cron which can call other docker containers

It's good approach to implement the cron as separated service without adding of the not necceraly complexity to the dockerized applications

Example of crontab.txt file: 

*/1 * * * * echo 23523 >> var/log/cron.log


CLI calls

docker build --tag cronos .
docker run 