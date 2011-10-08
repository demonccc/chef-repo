SSH CHETO

This plugins provide:

- All the ssh features of the standart plugin 
- You don't need to put the password in the parameters the command, it ask for you password
- Proxy command support
- SSH Cluster support 

Examples of use:

* Don't need to put the password in the parameters:

# knife ssh_cheto "fqdn:myserver*.example.com" uptime 
Enter your password: 
myserver01.example.com  23:10:32 up 5 day, 22:26,  1 user,  load average: 0.20, 0.15, 0.10
myserver02.example.com  23:10:32 up 8 day, 22:33,  1 user,  load average: 0.12, 0.13, 0.10

* Use of the proxy command support:

# knife ssh_cheto "fqdn:otherserver*.example.com" uptime --proxy-connect-command "connect-proxy -S 127.0.0.1:1081 %h %p" 
Enter your password: 
otherserver01.example.com  23:10:32 up 5 day, 22:26,  1 user,  load average: 0.20, 0.15, 0.10
otherserver02.example.com  23:10:32 up 8 day, 22:33,  1 user,  load average: 0.12, 0.13, 0.10

* Use of the SSH Cluster feature (you need to have installed the SSH Cluster application, http://sourceforge.net/projects/clusterssh):

knife ssh_cheto "fqdn:myserver*.example.com" cssh
