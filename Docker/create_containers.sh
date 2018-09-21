#!/bin/bash

echo -n "Name of file is: "
        read file
        while read user_name
            do 
                docker create -it --name $user_name docker_new /bin/bash
            done < $file
