FROM tricahyana/httpd
MAINTAINER Kasyfil Aziz Tri Cahyana <tricahyana@windowslive.com>

# install software apache and other software
RUN apt-get update && apt-get -y install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev libgdbm-dev libncurses5-dev automake libtool bison libffi-dev apache2-threaded-dev libapr1-dev libaprutil1-dev

# install rvm & install ruby
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN curl -L https://get.rvm.io | bash -s stable
RUN /usr/local/rvm/bin/rvm install 2.0.0
RUN bash -l -c "rvm use 2.0.0 --default"
RUN bash -l -c "gem install passenger -v 5.0.8"
RUN bash -l -c "gem install bundler"

# configure passangger
RUN printf \\n\\n\\n\\n | bash -l -c "passenger-install-apache2-module"
ADD apache2.conf /
RUN cat /apache2.conf >> /etc/apache2/apache2.conf

# run application
# COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
EXPOSE 22 80
# CMD ["/usr/bin/supervisord"]
CMD bash -c "source /etc/apache2/envvars ; \ 
	service apache2 restart ; \
	/usr/sbin/sshd -D"
