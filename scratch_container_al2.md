# amazon linux 2
## To stop all running containers and remove all containers
podman stop $(podman ps -a -q) && podman rm $(podman ps -a -q)
podman rmi $(podman images -q) --force
podman system prune -a --volumes --force


## spin up scratch cenv
```
podman run -d --platform linux/amd64 --name env-1 --network host amazonlinux:2 sleep infinity
podman exec -it env-1 yum install -y shadow-utils passwd sudo
podman exec -it env-1 bash -c 'useradd -m rdahlke && passwd -d rdahlke'
podman exec -it env-1 bash -c 'echo "rdahlke ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/rdahlke && chmod 440 /etc/sudoers.d/rdahlke'
podman exec -it --user rdahlke env-1 bash -c "cd ~ && bash"
```

## configure cloud desktop cenv
### setup ssh key pair and install mwinit
```
# this is all still in the container
sudo yum install -y openssh-clients json-c tar

if ssh-keygen -t ecdsa -f ~/.ssh/id_ecdsa -N "" > /dev/null 2>&1; then
    echo "SSH key generated successfully"
    cat ~/.ssh/id_ecdsa.pub
else
    echo "SSH key generation failed"
    exit 1
fi

# install mwinit // https://w.amazon.com/index.php/NextGenMidway/UserGuide#HDownloadthroughtheInternet
sudo rpm -i https://s3.amazonaws.com/com.amazon.aws.midway.software/linux/AmazonLinux2/x86-64/latest/amazon-midway-init.amzn2.x86_64.rpm
mwinit -o
```


### install toolbox
```
# https://docs.hub.amazon.dev/builder-toolbox/user-guide/getting-started/#clouddesk
touch ~/toolbox-bootstrap.sh && \
  curl -X POST \
  --data '{"os":"alinux"}' \
  -H "Authorization: $(curl -L \
  --cookie $HOME/.midway/cookie \
  --cookie-jar $HOME/.midway/cookie \
  "https://midway-auth.amazon.com/SSO?client_id=https://us-east-1.prod.release-service.toolbox.builder-tools.aws.dev&response_type=id_token&nonce=$RANDOM&redirect_uri=https://us-east-1.prod.release-service.toolbox.builder-tools.aws.dev:443")" \
  https://us-east-1.prod.release-service.toolbox.builder-tools.aws.dev/v1/bootstrap \
  > ~/toolbox-bootstrap.sh
bash ~/toolbox-bootstrap.sh
source ~/.$(basename "$SHELL")rc
toolbox update && toolbox install axe


```

## in container; test
sudo echo 0




if podman machine start 2>&1 | grep -q "Error: unable to start .* already running"; then
    echo "Podman machine was already running"
else
    echo "Podman machine has been started"
fi
podman stop $(podman ps -a -q) && podman rm $(podman ps -a -q)
podman rmi $(podman images -q) --force
podman system prune -a --volumes --force
podman run -d --platform linux/amd64 --name env-1 --network host amazonlinux:2 sleep infinity
podman exec -it env-1 yum install -y shadow-utils passwd sudo
podman exec -it env-1 bash -c 'useradd -m rdahlke && passwd -d rdahlke'
podman exec -it env-1 bash -c 'echo "rdahlke ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/rdahlke && chmod 440 /etc/sudoers.d/rdahlke'
podman exec -it --user rdahlke env-1 bash -c "cd ~ && bash"



# this is all still in the container
sudo yum install -y json-c openssh-clients tar

if ssh-keygen -t ecdsa -f ~/.ssh/id_ecdsa -N "" > /dev/null 2>&1; then
    echo "SSH key generated successfully"
    cat ~/.ssh/id_ecdsa.pub
else
    echo "SSH key generation failed"
    exit 1
fi

# install mwinit // https://w.amazon.com/index.php/NextGenMidway/UserGuide#HDownloadthroughtheInternet
sudo rpm -i https://s3.amazonaws.com/com.amazon.aws.midway.software/linux/AmazonLinux2/x86-64/latest/amazon-midway-init.amzn2.x86_64.rpm
mwinit -o


# https://docs.hub.amazon.dev/builder-toolbox/user-guide/getting-started/#clouddesk
touch ~/toolbox-bootstrap.sh && \
curl -X POST \
  --data '{"os":"alinux"}' \
  -H "Authorization: $(curl -L \
  --cookie $HOME/.midway/cookie \
  --cookie-jar $HOME/.midway/cookie \
  "https://midway-auth.amazon.com/SSO?client_id=https://us-east-1.prod.release-service.toolbox.builder-tools.aws.dev&response_type=id_token&nonce=$RANDOM&redirect_uri=https://us-east-1.prod.release-service.toolbox.builder-tools.aws.dev:443")" \
  https://us-east-1.prod.release-service.toolbox.builder-tools.aws.dev/v1/bootstrap \
  > ~/toolbox-bootstrap.sh
bash ~/toolbox-bootstrap.sh && rm ~/toolbox-bootstrap.sh
source ~/.$(basename "$SHELL")rc

