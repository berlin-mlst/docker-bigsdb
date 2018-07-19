# base
FROM ubuntu:18.04

# arguments and environment
ARG BIGSDB_VERSION=1.18.4
ARG DEBIAN_FRONTEND=noninteractive
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data

# core
RUN apt-get -y update && apt-get install -y \
   apache2 \
   bioperl \
   build-essential \
   cron \
   curl \
   emboss \ 
   exonerate \
   iputils-ping \
   less \
   libapache2-mod-perl2 \
   ncbi-blast+ \
   nano \
   perl \
   postgresql \
   postgresql-contrib \
   python-pip \
   wget \
   xvfb

# optional
RUN apt-get -y update && apt-get install -y \
   default-jdk \
   imagemagick \
   imagemagick-doc \
   mafft

# other software
WORKDIR /tmp
RUN wget https://www.drive5.com/muscle/downloads3.8.31/muscle3.8.31_i86linux64.tar.gz
RUN wget http://ab.inf.uni-tuebingen.de/data/software/splitstree4/download/splitstree4_unix_4_14_6.sh

# install perl modules
RUN perl -MCPAN -e 'install(Archive::Zip,Bio::Biblio,CGI,Config::Tiny,Crypt::Eksblowfish::Bcrypt,Data::UUID,DBD-Pg,DBI,Email::MIME,Email::Sender,Email::Valid,Error,Excel::Writer::XLSX,IO::String,JSON,List::MoreUtils,Log::Dispatch::File,Log::Log4perl,LWP::UserAgent,Net::Oauth,Parallel::ForkManager,Time::Duration,XML::Parser::perlSAX,Net::OAuth,Data::Random)'

# install splitstree
RUN chmod u+x splitstree4_unix_4_14_6.sh
RUN echo 'o\n1\n\n\n\n\n\n\n' > install.txt
RUN ./splitstree4_unix_4_14_6.sh < install.txt

# install muscle
# TODO

# download bigsdb, unpack, and copy files to appropriate locations
RUN wget https://github.com/kjolley/BIGSdb/archive/v_$BIGSDB_VERSION.tar.gz
RUN tar -xvf v_$BIGSDB_VERSION.tar.gz; \
   mkdir /var/www/cgi-bin; \
   cp BIGSdb-v_$BIGSDB_VERSION/bigsdb.pl /var/www/cgi-bin; \
   cp BIGSdb-v_$BIGSDB_VERSION/bigscurate.pl /var/www/cgi-bin; \
   cp BIGSdb-v_$BIGSDB_VERSION/bigsrest.pl /var/www/cgi-bin; \
   cp BIGSdb-v_$BIGSDB_VERSION/bigsjobs.pl /usr/local/bin; \
   ln -s /usr/local/bin/bigsjobs.pl /usr/local/bin/bigsjobs; \
   cp -r BIGSdb-v_$BIGSDB_VERSION/lib/BIGSdb /usr/local/lib/; \
   cp -r BIGSdb-v_$BIGSDB_VERSION/javascript /var/www/html/; \
   cp -r BIGSdb-v_$BIGSDB_VERSION/css /var/www/html/; \
   cp -r BIGSdb-v_$BIGSDB_VERSION/webfonts /var/www/html/; \
   cp -r BIGSdb-v_$BIGSDB_VERSION/images /var/www/html/; \
   cp -r BIGSdb-v_$BIGSDB_VERSION/conf /etc/; \
   mv /etc/conf /etc/bigsdb

# more copying of files (to be merged later)
# TODO: import python module(s): rauth
RUN cp BIGSdb-v_$BIGSDB_VERSION/scripts/automation/* /usr/local/bin; \
   cp BIGSdb-v_$BIGSDB_VERSION/scripts/maintenance/* /usr/local/bin; \
   cp BIGSdb-v_$BIGSDB_VERSION/scripts/monitoring/* /usr/local/bin; \
   cp BIGSdb-v_$BIGSDB_VERSION/scripts/query/* /usr/local/bin; \
   cp BIGSdb-v_$BIGSDB_VERSION/scripts/rest_examples/perl/* /usr/local/bin; \
   cp BIGSdb-v_$BIGSDB_VERSION/scripts/rest_examples/python/* /usr/local/bin

# import initialisation scripts
COPY config/bash/bigsdb_* /usr/bin/
RUN chmod a+x /usr/bin/bigsdb_*

# import bigsdb configuration files and menu_header.html into /etc/bigsdb
# TODO: move to bigsdb_configure
COPY config/bigsdb/conf/* /etc/bigsdb/

# copy apache2 site-config (this config file is automatically enabled by bigsdb_configure below)
COPY config/apache2/apache2_bigsdb.conf /etc/apache2/sites-available/

# Initialise container and start apache2
CMD ["bigsdb_configure"]




