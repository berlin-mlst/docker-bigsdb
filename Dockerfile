# base
FROM ubuntu:18.04

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
   postgresql-client \
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
#

# download bigsdb 1.18.3, unpack, and copy files to appropriate locations
RUN wget https://github.com/kjolley/BIGSdb/archive/v_1.18.3.tar.gz
RUN tar -xvf v_1.18.3.tar.gz; \
   mkdir /var/www/cgi-bin; \
   cp BIGSdb-v_1.18.3/bigsdb.pl /var/www/cgi-bin; \
   cp BIGSdb-v_1.18.3/bigscurate.pl /var/www/cgi-bin; \
   cp BIGSdb-v_1.18.3/bigsrest.pl /var/www/cgi-bin; \
   cp BIGSdb-v_1.18.3/bigsjobs.pl /usr/local/bin; \
   ln -s /usr/local/bin/bigsjobs.pl /usr/local/bin/bigsjobs; \
   cp -r BIGSdb-v_1.18.3/lib/BIGSdb /usr/local/lib/; \
   cp -r BIGSdb-v_1.18.3/javascript /var/www/html/; \
   cp -r BIGSdb-v_1.18.3/css /var/www/html/; \
   cp -r BIGSdb-v_1.18.3/webfonts /var/www/html/; \
   cp -r BIGSdb-v_1.18.3/images /var/www/html/; \
   cp -r BIGSdb-v_1.18.3/conf /etc/; \
   mv /etc/conf /etc/bigsdb

# import initialisation scripts
COPY config/bash/bigsdb_* /usr/bin/
RUN chmod a+x /usr/bin/bigsdb_*

# import bigsdb configuration files into /etc/bigsdb
COPY config/bigsdb/conf/*.conf /etc/bigsdb/

# copy apache2 site-config (this config file is automatically enabled by bigsdb_configure below)
COPY config/apache2/apache2_bigsdb.conf /etc/apache2/sites-available/

# Initialise container and start apache2
CMD ["bigsdb_configure"]




