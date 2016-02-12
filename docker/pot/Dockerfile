FROM jonatanschlag/honeyssh-base:latest
MAINTAINER jonatanschlag

ENV DEBIAN_FRONTEND noninteractive

ADD setup.sh /tmp/setup.sh
 
RUN chmod +x /tmp/setup.sh && /tmp/setup.sh

USER pot 

# Define default command.
CMD ["/opt/securehoney/sshpot"]

