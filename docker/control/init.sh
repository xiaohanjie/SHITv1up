#!/bin/sh

: "${SSH_PRIVATE_KEY?SSH_PRIVATE_KEY is empty, please use up.sh}"
: "${SSH_PUBLIC_KEY?SSH_PUBLIC_KEY is empty, please use up.sh}"
  echo $SSH_PRIVATE_KEY
  echo $SSH_PUBLIC_KEY

if [ ! -f ~/.ssh/known_hosts ]; then
    mkdir -m 700 ~/.ssh
    echo $SSH_PRIVATE_KEY | perl -p -e 's/↩/\n/g' > ~/.ssh/id_rsa
    chmod 600 ~/.ssh/id_rsa
    echo $SSH_PUBLIC_KEY > ~/.ssh/id_rsa.pub
    echo > ~/.ssh/known_hosts
    #for f in $(seq 1 5);do
    ssh-keyscan -t rsa 10.2.238.117  >> ~/.ssh/known_hosts
    #done
    sshpass -p "Root123" ssh-copy-id -i /root/.ssh/id_rsa 10.2.238.117
fi

# TODO: assert that SSH_PRIVATE_KEY==~/.ssh/id_rsa

#cat <<EOF 
#Welcome to Chaos on Docker
#===========================
#
#Please run \`docker exec -it chaos-control bash\` in another terminal to proceed.
#EOF

# hack for keep this container running
#/usr/sbin/init
#tail -f /dev/null
