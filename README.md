# CentOS Plex Dockerfile

This is a Dockerfile to set up "Plex Media Server" - (https://plex.tv/) running on Centos7.

## Preparation

Install [Docker](https://www.docker.com/).

Build from docker file

```
git clone git@github.com:wwebers/centos-plex.git
cd centos-plex
docker build -t plex .
```

You can also obtain it via:

```
docker pull wwebers/centos-plex
```

Prepare your local data folders used by the container volumes:

* /config - Create an empty folder. Plex will store its library, meta-data, preferences and other stuff here
* /data - This should point to your media

Instructions to run:

```
docker run -d --name plex --privileged -h *your_host_name* -v /*your_config_location*:/config -v /*your_data_location*:/data -p 32400:32400 plex
```

In case you prefer to share the hosts network you can run the container with the following command (Though be aware this more insecure but should be fine on your personal servers.)

```
docker run -d --name plex --privileged --net="host" -v /*your_config_location*:/config -v /*your_videos_location*:/data -p 32400:32400 plex
```

The first time it runs, it will initialize the config directory and terminate.

Browse to: ```http://*ipaddress*:32400/web``` to run through the setup wizard.

## Troubleshooting

### Access to Plex from within the local network

You will need to modify the auto-generated config file to allow connections from your local IP range. This can be done by modifying the file in either of the following alternatives:

*your_config_location*/Plex Media Server/Preferences.xml

* By allowing general access from within your local network by adding ```allowedNetworks="192.168.1.0/255.255.255.0" ``` as a parameter in the <Preferences ...> section. (Or what ever your local range is)
* By generally disabling network authentication by adding ```disableRemoteSecurity="1"``` as a parameter to the <Preferences ...> section.

Start the docker instance again and it will stay as a daemon and listen on port 32400.

### Access to the installation wizard from outside the local network

Per default Plex demands listens on 127.0.0.1 (localnet) and demands authentication from outside. To overcome this during the initial configuration one can build a SSH tunnel from whatever host and use that one during the initial configuration.

```ssh -f *your_docker_host* 2000:localhost:32400 -N```

Browse to: ```http://localhost:2000/web```to run the initial configuration

### Running the container under SELinux

Even though SELinux provides a lot to the security of Linux its currently quiet disturbing when running docker containers. Several commands demand either increased privileges or drop default capabilities already set by docker.

The current container does not run the plex-process with root-privileges. However, this demands the use of ```su -s /bin/sh plex -s ...```. For that reason the container is started with the ```--priviledged``` parameter. 

As a side-effect, one can make use of NFS-shares to configure the local data folder.
