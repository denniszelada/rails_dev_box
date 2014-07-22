# Fixes the annoying 'stdin: not a tty' message on Ubuntu
sed -i 's/^mesg n$/tty -s \&\& mesg n/g' /root/.profile

