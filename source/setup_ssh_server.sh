function psub  {
    perl -0pe 's/'"$1"'/'"$2"'/g'
}

if [[ "$OSTYPE" == "linux-gnu" ]] 
then
    if [[ -f /etc/debian_version ]] 
    then
        sudo apt-get update
        sudo apt-get install -y openssh-server net-tools pcregrep perl
        sudo ufw allow ssh 2>/dev/null
        sudo ufw allow from any to any port 2222 proto tcp 2>/dev/null
        
        echo "Making sure it starts at startup time"
        sudo systemctl enable ssh
        echo "Starting the SSH service right now"
        sudo service ssh start || sudo systemctl restart sshd
        
        echo "Your local IP address should be one of these:"
        ifconfig | pcregrep '192.[\d\.]+' | psub 'netmask.+' ''
        echo "Your public IP address should be:"
        curl ifconfig.co
    else
        echo "Sorry the only linux supported at the moment is debian"
        return 1
    fi
else
    echo "Sorry your OS isn't supported yet"
    return 1
fi