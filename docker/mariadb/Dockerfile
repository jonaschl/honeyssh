FROM jonatanschlag/honeyssh-base:latest
MAINTAINER jonatanschlag

ENV DEBIAN_FRONTEND noninteractive

#RUN apt-get update -y && apt-get install -y -y mariadb-server

#ADD my.cnf /etc/mysql/my.cnf
ADD setup.sh /tmp/setup.sh
 
RUN chmod +x /tmp/setup.sh && /tmp/setup.sh
ADD my.cnf /etc/mysql/my.cnf
#RUN apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

# Define mountable directories.
#VOLUME ["/etc/mysql", "/var/lib/mysql"]

# Define working directory.
WORKDIR /data

# Define default command.
CMD ["mysqld_safe"]

# Expose ports.
EXPOSE 3306
