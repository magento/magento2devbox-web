#!/bin/bash

# Run in foreground to warmup
su - magento2 -c "unison magento2"

# Run unison server
su - magento2 -c "unison -repeat=watch magento2 > /home/magento2/custom_unison.log 2>&1 &"
