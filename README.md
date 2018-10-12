# Intro

This repository is part of Magento DevBox, a simple way to install a Magento 2 development environment. 
The repository contains a Dockerfile for the Web container which includes Apache web server, PHP and a set of scripts to install Magento. The repository is used to automatically create an image https://hub.docker.com/r/magento/magento2devbox-web/, which is used for creating the development environment which you can create here https://magento.com/tech-resources/download.

# Comments, questions, bug reports, contributions?

Please use GitHub issue/pull request features to ask questions, reports bugs or provide contributions.

# What hosts are supported?

* 64-bit Windows 10 Pro, Enterprise and Education (1511 November update, Build 10586 or later) 
* Mac OS 10.10.3 "Yosemite" or later

# My site doesn't work after restart

Docker assigns a random free port to the container on restart. Run the m2devbox-reset script to reinitialize containers to use the proper port.
 
# Why do you use a script to generate the container files?

Using a script helps us provide a unique name for the containers, which allows you to run multiple sets of containers on one host. The script wraps the commands and also enables containers to run without conflict.
In the future, keys will be integrated so there will be no need to enter them.

# Why are Apache and PHP in the same container? Docker best practices suggest a container for each component...

Our goal was to create an easy to use development environment, not a production environment. The containers in Magento DevBox should not be used as a model for production use.

Additionally, when we tried separate containers, we encountered stability issues, especially when running multiple sets of containers. Docker is a quickly evolving product but it's not yet sufficiently stable. We are eager to revisit this approach and split the container in components, with option for nginx instead of Apache.

# What do you use for file sharing? What is this syncing process?

* MacOS: The shared filesystem is not performant enough. Magento worked too slowly.

  That is why we decided to use Unison (a file synchronization tool) to keep the local (inside Docker) web root directory in sync with files in the shared directory. It works quite well, although the initial synchronization takes a few minutes.

  We decided not to put Unison on the host machine (which would allow us not to use shared directories at all) to avoid adding dependencies. The MacOS shared filesystem supports notification events, so it can be used directly.

* Windows: The shared file system does not support notification events.

  For this reason, we require a locally installed Unison file synchronization tool, so it can pick up file changes.

# The initial startup is slow - why?

Our goal was to provide maximum flexibility. The container supports multiple methods of installing Magento (new installation, from existing local Magento code, or from Magento Enterprise Cloud Edition) and multiple editions (CE, EE, B2B).

For this reason, we do not include Magento files in the Docker image, but instead use Composer to download the files on first start. This is a slower approach than other images you might find on Docker hub; however, it allows us to configure Magento to suit your needs.

We are considering embedding some of the files into the container for a faster start.

# Why do you include Redis, Varnish, Elasticsearch and RabbitMQ?

We think that you should develop as much as possible in an environment resembling a production configuration. In the majority of cases, a production configuration includes those components (Elasticsearch and RabbitMQ for Magento EE deployments).

This approach allows you to catch early issues related to incompatibility instead of finding those issues at the last moment. During Magento DevBox installation, use *Advanced Options* to choose which of these components to install.

# Warmup

By default, to save installation time, no warmup is performed. If you would like to use the container for demo purposes, you can enable warmup.

# Cron

By default, to save batteries/energy, cron is disabled. Our experience shows, that running cron in container results in very quick draining of laptop batteries.