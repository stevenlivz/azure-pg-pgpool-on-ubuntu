#!/bin/bash
# Execute command by failover.
# special values:  %d = node id
#                  %h = host name
#                  %p = port number
#                  %D = database cluster path
#                  %m = new master node id
#                  %M = old master node id
#                  %H = new master node host name
#                  %P = old primary node id
#                  %% = '%' character
failed_node_id=$1
failed_host_name=$2
failed_port=$3
failed_db_cluster=$4
new_master_id=$5
old_master_id=$6
new_master_host_name=$7
old_primary_node_id=$8
#trigger=/var/lib/postgresql/9.4/trigger/trigger_file
trigger=/var/lib/kafkadir/trigger/trigger_file
#trigger=/var/lib/kafkadir/main/failover # trigger file for the Azure install

logger "Failover vars"
whoami | logger
logger $failed_node_id
logger $failed_host_name
logger $failed_port
logger $failed_db_cluster
logger $new_master_id
logger $old_master_id
logger $new_master_host_name
logger $old_primary_node_id
logger "End Failover vars"

if [ $failed_node_id = $old_primary_node_id ];then      # master failed
  logger "Promoting $old_master_id"

  # We let the standby take over
    sshpass -p "PASSWORD" ssh -o StrictHostKeyChecking=no -T trigger@$old_master_id touch $trigger     # let standby take over
        #sshpass -p "triggerpass" ssh -T trigger@$new_master_host_name touch $trigger       # let standby take over
        #ssh -T postgres@$new_master_host_name touch $trigger       # let standby take over

    # Stop all the slaves ... this is because AT THE MOMENT we don't know how to
    # update the recovery.conf in a docker container - when we retsart Postgres it
    # goes back to what it was. So we need to MANUALLY update the yml for each Slave
    # to specify the new master IP and restart them
    # Get all the items in PGPool and enumerate them, stopping all except the old and new master
  node_count=`pcp_node_count -h localhost -p 9898 -U muser -w | awk '{print $0}'`
  logger "Node Count $node_count"


# compare failed_host_name and old_master_id to that in node info below and stop all but those ... the master returns a connectionerror, so skip that too
for ((node_index=0; node_index<=node_count-1; node_index++))
  do
    logger "Node Item $node_index"

     # get the ip of this node to compare
     node_ip=`pcp_node_info -h localhost -p 9898 -U muser -w -n $node_index | awk '{print $1}'`
     if [ $node_ip != $failed_host_name ] && [ $node_ip != 'BackendError' ] && [ $node_ip != $old_master_id ];then

        logger "Detatching Node $node_index"

        # detatch in the background to prevent hanging the shell
        pcp_detach_node -h localhost -p 9898 -U muser -w -n $node_index &

        #Stop the remote postgres instance. To get this to work we need to make "trigger" have permissions to manage postgres.
        #Doing this however will stop all databases which may be a pain if we quickly push the older Master up again.
        #It is also a pain to *restart* containers with the new config as they lose their updated state.
        #sshpass -p "triggerpass" ssh -o StrictHostKeyChecking=no -T trigger@$node_ip /etc/init.d/postgresql stop &
     fi
  done

fi