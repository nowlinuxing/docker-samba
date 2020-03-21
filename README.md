# docker-samba

Simple samba server on docker

## Build a container

```sh
$ sudo docker build -t samba .
```

## Usage

```sh
$ ./up.sh username uid gid /path/to/share/dir
```
If you want to pass the same parameters every time, you can also specify a JSON file containing the settings.

```sh
$ cat param.json
{
  "user": {
    "name": "user",
    "uid": 1000,
    "gid": 1000
  },
  "share": {
    "path": "/path/to/dir"
  }
}

$ ./up.sh param.json
```

## Debugging samba

### Show all samba users

```sh
$ pdbedit -L -v
```

### Access to samba

```sh
$ sudo apt install smbclient

# Get a list of shares (as a guest)
$ smbclient -L IPADDR -U%

# Get a list of shares (as a signed user)
$ smbclient -L IPADDR
```

```sh
# Connect to samba
$ smbclient //IPADDR/share
```

### Links

* [Setting up Samba as a Standalone Server - SambaWiki](https://wiki.samba.org/index.php/Setting_up_Samba_as_a_Standalone_Server)
* [Samba - ArchWiki](https://wiki.archlinux.org/index.php/Samba)
