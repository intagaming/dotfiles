mkdir -p ~/.1password
set -x SSH_AUTH_SOCK ~/.1password/agent.sock
set ALREADY_RUNNING (ps -auxww | grep -q "[n]piperelay.exe -ei -s //./pipe/openssh-ssh-agent"; echo $status)

if [ $ALREADY_RUNNING != "0" ]
    if [ -S $SSH_AUTH_SOCK ]
        echo "removing previous socket..."
        rm $SSH_AUTH_SOCK
    end

    echo "Starting SSH-Agent relay..."
    setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork >/dev/null 2>&1 &
end
