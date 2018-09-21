## Docker Case Study - Automate Infra allocation for L&D

### **Requirements**-
1. Dynamic Allocation of Linux systems for users
2. Each user should have independent Linux System
3. Specific training environment should be created in Container
4. User should not allow to access other containers/images
5. User should not allow to access docker command
6. Monitor participants containers
7. Debug/live demo for the participants if they have any doubts/bug in running applications. 
8. Automate container creation and deletion.

### Creating the container image 
1. Make sure that you have some base image from which new container can be created.

2. Create the new container using this command:

`docker create -it --name docker_new ubuntu /bin/bash`

3. Start and attach to container

```
docker start docker_new
docker attach docker_new
```

4. Install packages in the container as per requirement. Eg. vim, gcc etc.

```
apt update
apt install vim
apt install gcc
```

5. Create assessment_questions.txt, instrunctions_list.txt required for the assessment and save them.

6. Commit the container with the following command: 

`docker commit -a "Akshi" 2a1751d9e6bb docker_new`

With this, the training container image is ready for usage.

### Allocating Containers To Users
1. Let us create a text file containing the names of all the users.

    - `users.txt`
        ```
        Akshi
        Shreya
        Mudita
        ```
2. Run the shell script `sh create_containers.sh -x`.This creates a docker container corresponding to each username from `users.txt.

    - `create_containers.sh`
        ```
        echo -n "Name of file is: "
        read file
        while read user_name
            do 
                docker create -it --name $user_name docker_new /bin/bash
            done < $file
        ```
3. The user can then start using the allocated container with the following commands after staring a new shell

	`docker start <name> # Starts the container`\
	`docker exec -it <name> /bin/bash`


### Localisation

Next, we need to ensure that the users cannot access others users' containers.This can be accomplished by adding the following lines to every user's _.bashrc_.

```
docker start -ai <name>
exit
```
>Note: A script can also be written to automate the above process for all users.

Now, the user will directly connect to the docker container on connecting to the system.

Also, the command _exit_ which was added to the end of user's _.bashrc_ will force the user to exit the system everytime he/she exits the container. This will not allow him/her to access other users' containers.

_Network isolation_ disables the users to connect to other users' containers while being inside the container. All the data is strictly localised by default.

### Monitoring The Containers
The instructor can monitor the containers in many ways. 
- `docker stats <user>` #To see usage stats of containers

```
CONTAINER ID        NAME                CPU %               MEM USAGE / LIMIT   MEM %               NET I/O             BLOCK I/O           PIDS
2a1751d9e6bb        Akshi               0.00%               0B / 0B             0.00%               0B / 0B             0B / 0B             0
```
  
- `docker logs -f <user>` (To see logs of a container)

  
- `docker attach <user> # The container shuts down when exited` (Attach to a container)

  
- `docker exec -it <user> bin/bash #The container continues to run when exited` (Start a new shell, take control) 

### Deleting The Containers
- Automate the deletion using the `delete_containers.sh` script.

    - `delete_containers.sh`
        ``` 
        echo -n "Enter the file name: "
        read file
        while read user_name
            do
              docker stop $user_name  
              docker rm $user_name
            done < $file
        ```
- You can either delete all users or user by name using the command ` sh delete_containers.sh -x`.
