# runpod-hashcat-ssh

Dockerfile hosting hashcat, compatible with rundpod.io's pods

Hashcat dockerfile has been copied from https://github.com/dizcza/docker-hashcat/blob/master/Dockerfile

Updated dockerfile to use CUDA 12.1.1, uses latest version of hashcat and enables SSH to be used in runpod's pods.

For now, the only wordlist on my dockerhub is `rockyou.txt` since I made this project to be used for CTFs, below you can also find a small tutorial on how to add your own wordlist

# Setting up runpod

First create an account and add a few credits

Next add your SSH public key to your runpod profile. (https://www.runpod.io/console/user/settings)

Next, go to Pods > +GPU Pod

Click on `Choose Template` and search for "hashcat-ssh" in the Community Templates

Next, choose which GPU(s) to use and click deploy.

Once the Pod has been initialized, click on "Connect" and copy the SSH command.

Once you have connected over SSH, you can find the following tools in the `tools` folder in the `/root` directory:
- hashcat
- hashcat-utils
- hcxdumptool
- hcxtools
- kwprocessor

There is also a `wordlists` folder that only contains the `rockyou.txt` wordlist. If you would like to add your own wordlists then view the below section for creating your own docker hub repo and runpod template

# Add custom wordlist 

To add your own wordlists to the container you need to create your own dockerhub repo and create your own runpod template to pull said repo.

First clone the above repo and mv/cp your wordlist(s) to the `wordlists` folder.

Next build the image:

```
docker build --tag <dockerhub-username>/<repo-name>:<tag> .
```

Next push the image to docker hub:
```
docker push <dockerhub-username>/<repo-name>:<tag>
```

Now create a custom Template on runpod to use your docker hub repo, navigate to Templates and click "+ New Template"

Add the following:
- Template Name
- Container image - The one you created with the previous command
- Expose TCP Ports - 22

Save the Template, and follow the same steps mentioned above: [Setting up runpod](#Setting-up-runpod)


Happy cracking