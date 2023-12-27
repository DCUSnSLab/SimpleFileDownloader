FROM nginx
COPY nginx.conf /etc/nginx/nginx.conf

ENV USER snslab

RUN apt-get update
RUN apt-get install -y ssh openssh-server python3 python3-dev python3-pip git vim sudo
RUN mkdir /var/run/sshd
 
#replace sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
 
#set sudo for $USER
RUN sed -ri '20a'$USER'    ALL=(ALL) NOPASSWD:ALL' /etc/sudoers
 
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
 
#make .ssh
RUN useradd -m $USER
RUN mkdir /home/$USER/.ssh
RUN chown $USER.$USER /home/$USER/.ssh
RUN chmod 700 /home/$USER/.ssh

WORKDIR /static_files
RUN chown $USER.$USER /static_files
 
#set password
RUN echo 'root:wwwsnslab' |chpasswd
RUN echo $USER':wwwsnslab' |chpasswd

EXPOSE 22

CMD service ssh start && nginx -g 'daemon off;'