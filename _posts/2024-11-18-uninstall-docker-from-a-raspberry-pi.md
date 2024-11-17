---
title: "Step-by-Step Guide to Managing and Uninstalling Docker on Raspberry Pi"
categories:
  - RaspberryPi
  - Docker
tags:
  - RaspberryPi
  - Docker
---

# Table Of Contents
- [Table Of Contents](#table-of-contents)
- [Introduction](#introduction)
- [Check Installed Docker Packages](#check-installed-docker-packages)
  - [Command](#command)
  - [Possible Results](#possible-results)
- [Remove Docker Packages](#remove-docker-packages)
  - [Commands](#commands)
  - [Execution Methods](#execution-methods)
  - [Additional Notes](#additional-notes)
    - [1. Recommended Packages to Remove](#1-recommended-packages-to-remove)
    - [2. Use of `sudo`](#2-use-of-sudo)
    - [3. Difference Between `remove` and `purge`](#3-difference-between-remove-and-purge)
- [Remove All Docker-Related Data](#remove-all-docker-related-data)
- [Deactivate Docker Network Interface and Ethernet Bridge](#deactivate-docker-network-interface-and-ethernet-bridge)
  - [Disable `docker0` Network Interface](#disable-docker0-network-interface)
  - [Delete the `docker0` Ethernet Bridge](#delete-the-docker0-ethernet-bridge)
- [Conclusion](#conclusion)
  - [Key Considerations for Raspberry Pi Users:](#key-considerations-for-raspberry-pi-users)

# Introduction

Docker is a lightweight containerization platform that works exceptionally well on devices like the Raspberry Pi. However, there may be situations where you need to identify installed Docker packages, completely remove them, or clean up associated resources. 

This guide is tailored for Raspberry Pi users and provides a comprehensive approach to:

1. Checking installed Docker packages on your Raspberry Pi.
2. Fully removing Docker and its related packages.
3. Cleaning up residual data, such as images, containers, and volumes.
4. Deactivating Docker-related network interfaces.

Whether you're troubleshooting, performing a clean uninstall, or switching to a different container solution, these steps will ensure no traces of Docker remain on your Raspberry Pi.

---

# Check Installed Docker Packages

## Command
```bash
dpkg -l | grep -i docker
```

## Possible Results
You may encounter any combination of the following packages:
- `docker`
- `docker-ce`
- `docker-compose`
- `docker-doc`
- `docker-engine`
- `docker.io`
- `podman-docker`

---

# Remove Docker Packages

## Commands
To completely remove Docker packages from your Raspberry Pi, use the following commands:

```bash
apt-get purge
apt-get autoremove
```

## Execution Methods
You can execute these commands in the following ways:

1. **Sequential Execution for Each Package**
   ```bash
   apt-get purge -y <package-name>...
   apt-get autoremove -y <package-name>...
   ```

2. **Single Command for Multiple Packages**
   ```bash
   apt-get purge -y <packageA-name> <packageB-name> <packageC-name>...
   apt-get autoremove -y <packageA-name> <packageB-name> <packageC-name>...
   ```

3. **Using a For-Loop**
   ```bash
   for pkg in <packageA-name> <packageB-name> <packageC-name>...; do
       apt-get purge -y $pkg
       apt-get autoremove -y $pkg
   done
   ```

## Additional Notes

### 1. Recommended Packages to Remove
The [official Docker documentation for Raspberry Pi OS](https://docs.docker.com/engine/install/raspberry-pi-os/#uninstall-old-versions) suggests removing the following packages to completely clean up Docker installations:
- `containerd`
- `runc`

### 2. Use of `sudo`
If you are not logged in as a root user on your Raspberry Pi, prepend all commands with `sudo`. For example:
```bash
sudo apt-get purge -y <package-name>
```

### 3. Difference Between `remove` and `purge`
The Docker documentation suggests using `apt-get remove`. However, it is preferable to use `apt-get purge` in combination with `apt-get autoremove` as this ensures removal of both the package and its associated system-wide configuration files.

---

# Remove All Docker-Related Data

To remove Docker-related images, containers, volumes, and configurations from your Raspberry Pi, execute the following commands:

```bash
sudo umount /var/lib/docker/
sudo rm -rf /var/lib/docker
sudo rm -rf /etc/docker
sudo rm /etc/apparmor.d/docker
sudo rm -rf /var/lib/containerd
sudo rm -rf /var/run/docker.sock
sudo rm -rf /usr/bin/docker-compose
sudo rm /etc/apt/sources.list.d/docker.list
sudo rm /etc/apt/keyrings/docker.asc
sudo groupdel docker
```

---

# Deactivate Docker Network Interface and Ethernet Bridge

## Disable `docker0` Network Interface
To deactivate the `docker0` network interface on your Raspberry Pi, run:
```bash
sudo ifconfig docker0 down
```

## Delete the `docker0` Ethernet Bridge
To remove the `docker0` Ethernet bridge, run:
```bash
sudo ip link delete docker0
```

---

# Conclusion

By following the steps outlined in this guide, you can thoroughly identify, remove, and clean up all Docker-related packages, configurations, and data from your Raspberry Pi. This ensures no residual files or configurations are left behind, which is essential for troubleshooting, fresh installations, or switching to alternative containerization tools.

## Key Considerations for Raspberry Pi Users:
- Ensure your Raspberry Pi user has adequate administrative privileges for these commands (`sudo` may be required).
- Be cautious about other applications that may depend on Docker before proceeding with the removal.

For further assistance, refer to the [official Docker documentation for Raspberry Pi OS](https://docs.docker.com/engine/) or consult the Docker community forums.