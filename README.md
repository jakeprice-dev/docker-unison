# Unison Sync Docker Image

This Dockerfile will build an image to run [Unison File Synchronizer](https://www.cis.upenn.edu/~bcpierce/unison/). 

I use it for devices within my LAN to sync files between servers and virtual machines.

## Build Instructions

```sh
docker build --tag unison-docker:<label> .
```

## Usage Instructions

```sh
docker run \
    --rm \
    --env UNISONLOCALHOSTNAME=<device-hostname> \
    --volume ~/.unison:/home/unison/.unison \
    --volume ~/.ssh:/home/unison/.ssh \
    --volume /var/log:/var/log \
    --volume <directory-to-sync> \
    --interactive --tty \
    unison-docker:<label> -batch <unison-profile>
```

You must set the `UNISONLOCALHOSTNAME` environment variable to avoid Unison creating new archives on each `docker run`. If you don't do this they will have a new hostname on each run of `unison-docker` and Unison will create a new archive file on each run (this is because the containers are ephemeral).

Each device that runs the container must have a Unison profile (`example-01.prf`). You should use the profile name to perform a sync using that profile. Use the name of the profile only (without the `.prf` file ending).

