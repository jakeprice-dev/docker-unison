# Unison Sync Docker Image

This Dockerfile will build an image to run [Unison File Synchronizer](https://www.cis.upenn.edu/~bcpierce/unison/). 

I use it for devices within my LAN to sync files between servers and virtual machines.

## Usage Instructions

### Docker Run

#### Example

```sh
docker run \
    --rm \
    --user <uid>:<gid> \
    --env UNISONLOCALHOSTNAME=<hostname> \
    --volume /etc/timezone:/etc/timezone:ro \
    --volume /etc/localtime:/etc/localtime:ro \
    --volume /etc/passwd:/etc/passwd \
    --volume $HOME/.unison:/home/<username>/.unison \
    --volume $HOME/.unison_sync.log:/home/<username>/.unison_sync.log \
    --volume $HOME/.ssh/<remote-hostname>:/home/<username>/.ssh/<remote-hostname> \
    --volume $HOME/.ssh/known_hosts:/home/<username>/.ssh/known_hosts \
    --volume <directory-to-sync>:<directory-to-sync> \
    --interactive --tty jakepricedev/docker-unison:<tag-name> <unison-command> <profile-name>
```

#### Real World Example

A real world example is probably quite helpful here. I run the below via a bash alias on my laptop to sync with my file server.

```sh
docker run \
    --rm \
    --user 1000:1000 \
    --env UNISONLOCALHOSTNAME=elitebook \
    --volume /etc/timezone:/etc/timezone:ro \
    --volume /etc/localtime:/etc/localtime:ro \
    --volume /etc/passwd:/etc/passwd \
    --volume $HOME/.unison:/home/jprice/.unison \
    --volume $HOME/.unison_sync_elitebook.log:/home/jprice/.unison_sync_elitebook.log \
    --volume $HOME/.ssh/main-01:/home/jprice/.ssh/main-01 \
    --volume $HOME/.ssh/known_hosts:/home/jprice/.ssh/known_hosts \
    --volume $HOME/my:/home/jprice/my \
    --interactive --tty jakepricedev/docker-unison:2.52.1-r0 -batch elitebook
```

Let's walk through the command, flag-by-flag.

- `--user 1000:1000` should specify the UID and GID of the user running the image, which should also be the owner of the directory you are syncing.
- `--env UNISONLOCALHOSTNAME=` should equal your local device's hostname (the hostname of the device you are syncing _from_, not the hostname of the device you are syncing _to_). This is important with Docker, especially when running the image with `--rm` as the container's hostname will change on each run, and Unison will want to create a new archive everytime.
- `--volume /etc/passwd:/etc/passwd` mounts your local machines `passwd` file, which maps the UID/GID to a username and group, to allow Unison to work correctly.
- `--volume $HOME/.unison:/home/jprice/.unison` mounts the Unison directory which will contain archive files and your profile(s) to make sure anything Unison does on the container is also stored on the local device.
- `--volume $HOME/.unison_sync_elitebook.log:/home/jprice/.unison_sync_elitebook.log` mounts the `logfile` specified in your Unison profile.
- `--volume $HOME/.ssh/known_hosts:/home/jprice/.ssh/known_hosts` mounts the remote device's known_hosts file, so you don't have to accept the remote host's fingerprint.
- `--volume $HOME/.ssh/main-01:/home/jprice/.ssh/main-01` mounts the remote device's private key, allowing Unison to connect and sync securely.
- `--volume /home/jprice/my:/home/jprice/my \` mount's the directory you are syncing with Unison.

##### Unison Profile

Here's the Unison profile I use with the above command. Remember the profile will be read by the Unison instance running on the docker container, not your local machine, so the below paths should actually match the second half of your mount commands. So I'm using the full path to my `home` directory instead of `~`.

```ini
# Sync roots
root=/home/jprice/my
root=ssh://ppn-admin@main-01.lan//mnt/data-ssd-01/my

# Sync options:
sshargs=-oIdentityFile=/home/jprice/.ssh/main-01

# Sync paths:
path=backup
path=files/code
path=files/documents
path=files/inbox
path=files/media

# Log options:
log=true
logfile=/home/jprice/.unison_sync_elitebook.log
```

## Interactive and Cron

Remove the `--interactive` flag if you are going to run the Docker `run` command as a cronjob to avoid issues.

If you need to manually reconcile some differences, you'll need to add the `--interactive` flag back, so you can interact with the questions Unison will ask.

