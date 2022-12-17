# Unison Sync Docker Image

This Dockerfile will build an image to run [Unison File Synchronizer](https://www.cis.upenn.edu/~bcpierce/unison/). 

I use it for devices within my LAN to sync files between servers and virtual machines.

## Usage Instructions

```sh
docker run \
    --rm \
    --env UNISONLOCALHOSTNAME=<hostname> \
    --volume /etc/timezone:/etc/timezone:ro \
    --volume /etc/localtime:/etc/localtime:ro \
    # Mount Unison profile: \
    --volume <path-to-profile>/<profile-name>.prf:/home/unison/.unison/<profile-name>.prf \
    # Mount Unison archive files:
    --volume ~/.unison:/home/unison/.unison \
    # Mount private key for syncing from the remote root:
    --volume ~/.ssh:/home/unison/.ssh \
    # Mount the directory to sync:
    --volume <sync-directory-path>/:/home/unison/my/ \
    # Mount the log file:
    --volume /tmp/.unison_sync.log:/tmp/.unison_sync.log \
    --interactive --tty \
    jakepricedev/docker-unison:<label> -batch <hostname>
```

You must set the `UNISONLOCALHOSTNAME` environment variable to your device's hostname to avoid Unison creating new archives on each `docker run`. If you don't do this Unison will use the Docker container's hostname which based on the usage example above will be different on each run (because of `--rm` making the container ephemeral).

Remember your profile will be read by the Unison instance running on the docker container, not your local machine, so the root folder you are syncing should be present on the container when it is run. We mount the profile, archive files and sync directory to ensure the container is syncing to our local machine via the mounts.

