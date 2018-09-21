echo -n "Enter the file name: "
        read file
        while read user_name
            do
              docker stop $user_name  
              docker rm $user_name
            done < $file
