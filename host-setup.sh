SERVER_FILE=servers.txt
ETC_HOST_FILE=hosts
PUBLIC_KEY_FILE=id_rsa-hdp.pub
hostname_prefix=ambariTest

public_key=`cat $PUBLIC_KEY_FILE`

ssh_target=`head -n 1 $SERVER_FILE` # this will be the ambari server
echo "ambari server: $ssh_target"

fqdn_arr=(`cat $SERVER_FILE | xargs`)
counter=0

# initialize etc host
echo "127.0.0.1       localhost.localdomain localhost" > $ETC_HOST_FILE
echo "::1     localhost6.localdomain6 localhost6" >> $ETC_HOST_FILE

for i in `cat $SERVER_FILE | xargs`
do
  local_ip=`ssh root@$ssh_target ping $i | head -n 1 | awk -F\( '$0=$2' | awk -F\) '$0=$1'`
  line_output="$local_ip ${fqdn_arr[$counter]} $hostname_prefix$counter"
  echo $line_output >> $ETC_HOST_FILE

  # set hostname on all nodes
  # copy the public to all nodes
  ssh root@$i "hostname $hostname_prefix$counter && echo $public_key >> ~/.ssh/authorized_keys"

  ((counter++))
done

# copy the etc host file to all nodes
for i in `cat $SERVER_FILE | xargs`
do
  scp $ETC_HOST_FILE root@$i:/etc/hosts
done

