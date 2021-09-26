#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install nginx1 -y
instance_ip=`curl -s http://169.254.169.254/latest/meta-data/local-ipv4`
region=`curl -s http://169.254.169.254/latest/meta-data/placement/region`
az=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
echo "<html><body>Instance IP: $instance_ip</br>Region: $region</br>Availability Zone: $az</body></html>" | sudo tee /usr/share/nginx/html/index.html
sudo sed -i 's/listen       80;/listen       8888;/' /etc/nginx/nginx.conf
systemctl start nginx.service
systemctl enable nginx.service
sudo useradd -m -d /home/teacher -s /bin/bash -g wheel teacher
sudo mkdir /home/teacher/.ssh
sudo echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCkBIEsfJD6d0J4tqTnVq4z3Ve0bop71b+27j75gncRsLdAokiUqGyt1fmvS+VkoBWxOFiAOsfdSdTwJWyGs0kplZouOh93cRc/9mp16mNcR5B86+ORLrMZCq3ZGVj2F3YjtoeK4b+RvEtpRmJaC/no9yjTeDTnBYVsV+vQvxiaaeLzkbPRhd0Ovlayoz/gXqI4DOCaQTfISHxG7X+NLfpWR6LsfaHYKG/5WmaA3LOnYAqV+S7nq2WQVQ2Z5bzpJC9s= andrey@MBP-Andrey' >> /home/teacher/.ssh/autorized_keys
sudo chown -R teacher:teacher /home/teacher/.ssh
sudo chmod 600 /home/teacher/.ssh/authorized_keys
sudo chmod 700 /home/teacher/.ssh