Assumption: you can ssh as root to your aws machines from your local box without entering the password.
1) Copy aws' external dns names to servers.txt
2) Make sure that you have id_rsa-hdp.pub. If you don't have one, generate one.

--Put Tim's bash foo into a script.
--From a high level, it sets up fqdn and hostname and copies ssh keys and /etc/hosts to all the nodes, so you don't need to.
