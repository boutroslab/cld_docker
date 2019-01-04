FROM sebp/lighttpd

MAINTAINER Oliver Pelz "o.pelz@gmail.com"

# RUN wget http://dl-cdn.alpinelinux.org/alpine/v3.4/main/x86_64/APKINDEX.tar.gz

RUN \
    apk add --update --no-cache \    
    # apt-get update \
    # && apt-get install --no-install-recommends --no-install-suggests -y \
    unzip \
    perl \
    perl-dev \
    wget \
    rsync \
    curl \
    gcc g++ make \ 
    #build-essential \
    expat \
    zlib \
    libxt-dev \
    libxml2-dev \
    gd-dev \
    graphviz-dev \
   	libc6-compat \
	libstdc++ \
    sudo \
    git \
    #apulse \
    #dirmngr \
	gnupg \	
	mesa-gl \
	chromium \
	ca-certificates \
	ffmpeg \
	#firefox \
	hicolor-icon-theme \
	#libasound2 \
	#libgl1-mesa-dri \
	#libgl1-mesa-glx \
	#libpulse0 \
	#fonts-noto \
	#fonts-noto-cjk \
	#fonts-noto-color-emoji \
    db-dev
  # needed for bowtie2
RUN \
    apk --no-cache add --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ \
    libtbb libtbb-dev 
  #  gdebi && rm -rf /var/lib/apt/lists/*
RUN \
     rm -rf /var/cache/apk/*

# first build clustalw because this is needed before installing the perl interface for it
RUN cd /tmp; wget http://www.clustal.org/download/1.X/ftp.bio.indiana.edu/molbio/align/clustal/old/clustalw1.75.unix.tar.Z; tar xvf clustalw1.75.unix.tar.Z; cd clustalw1.7; make; cp clustalw /usr/bin/
#RUN cd /tmp; wget http://www.clustal.org/download/current/clustalw-2.1.tar.gz; tar xvf clustalw-2.1.tar.gz; cd clustalw-2.1; ./configure --prefix=/usr/; make; make install


# now install the reannotate-crispr PERL package
# for CPAN to auto say yes to every question
ENV PERL_MM_USE_DEFAULT=1
RUN perl -MCPAN -e 'CPAN::Shell->install("Bundle::CPAN")'
RUN perl -MCPAN -e 'CPAN::Shell->install("FCGI")'
RUN perl -MCPAN -e 'CPAN::Shell->install("Bio::Perl")'
# now install all the modules we need for crispr reannotator
RUN perl -MCPAN -e 'CPAN::Shell->install("Bio::DB::Fasta")'
RUN perl -MCPAN -e 'CPAN::Shell->install("Bio::SeqIO")'
RUN perl -MCPAN -e 'CPAN::Shell->install("Bio::Tools::GFF")'
RUN perl -MCPAN -e 'CPAN::Shell->install("Scalar::Util")'
RUN perl -MCPAN -e 'CPAN::Shell->install("Bio::SeqFeature::Generic")'
RUN perl -MCPAN -e 'CPAN::Shell->install("Bio::Location::Split")'
RUN perl -MCPAN -e 'CPAN::Shell->install("Bio::Graphics")'
RUN perl -MCPAN -e 'CPAN::Shell->install("JSON::XS")'
RUN perl -MCPAN -e 'CPAN::Shell->install("File::Slurp")'
RUN perl -MCPAN -e 'CPAN::Shell->install("List::MoreUtils")'
RUN perl -MCPAN -e 'CPAN::Shell->install("List::Util")'
RUN perl -MCPAN -e 'CPAN::Shell->install("Archive::Zip")'
RUN perl -MCPAN -e 'CPAN::Shell->install("Parallel::ForkManager")'
RUN perl -MCPAN -e 'CPAN::Shell->install("Cwd")'
RUN perl -MCPAN -e 'CPAN::Shell->install("Getopt::Long")'
RUN perl -MCPAN -e 'CPAN::Shell->install("File::Grep")'
RUN perl -MCPAN -e 'CPAN::Shell->install("Text::Wrap")'
RUN perl -MCPAN -e 'CPAN::Shell->install("Unix::Processors")'
RUN perl -MCPAN -e 'CPAN::Shell->install("Spreadsheet::WriteExcel")'
RUN perl -MCPAN -e 'CPAN::Shell->install("Text::CSV::Simple")'
RUN perl -MCPAN -e 'CPAN::Shell->install("Tk")'
RUN perl -MCPAN -e 'CPAN::Shell->install("IPC::Cmd")'
RUN perl -MCPAN -e 'CPAN::Shell->install("Getopt::Long")'
RUN perl -MCPAN -e 'CPAN::Shell->install("File::Grep")'
RUN perl -MCPAN -e 'CPAN::Shell->install("Text::Wrap")'
RUN perl -MCPAN -e 'CPAN::Shell->install("Unix::Processors")'
RUN perl -MCPAN -e 'CPAN::Shell->install("Tk::PathEntry")'					#loads the interactive pathentry widget
RUN perl -MCPAN -e 'CPAN::Shell->install("Tk::Dialog")'						#loads the Tk Fileopener dialog widget
RUN perl -MCPAN -e 'CPAN::Shell->install("Tk::Dressing")'
RUN perl -MCPAN -e 'CPAN::Shell->install("Tk::BrowseEntry")'
RUN perl -MCPAN -e 'CPAN::Shell->install("Tk::Optionmenu")'
RUN perl -MCPAN -e 'CPAN::Shell->install("Tk::Widget")'
RUN perl -MCPAN -e 'CPAN::Shell->install("Tk::Frame")'
RUN perl -MCPAN -e 'CPAN::Shell->install("Tk::Entry")'
RUN perl -MCPAN -e 'CPAN::Shell->install("Tk::Label")'
RUN perl -MCPAN -e 'CPAN::Shell->install("Tk::Button")'
RUN perl -MCPAN -e 'CPAN::Shell->install("Tk::Scrollbar")'
RUN perl -MCPAN -e 'CPAN::Shell->install("Tk::Checkbutton")'
RUN perl -MCPAN -e 'CPAN::Shell->install("Tk::MainWindow")'
RUN perl -MCPAN -e 'CPAN::Shell->install("Tk::NoteBook")'
RUN perl -MCPAN -e 'CPAN::Shell->install("Tk::Text::SuperText")'

# force installation of clusteralw as almost all unit tests fail
# during installation and it refuses to do so
# RUN perl -MCPAN -e 'CPAN::Shell->install("Bio::Tools::Run::Alignment::Clustalw")'
RUN cpan -f -i 'Bio::Tools::Run::Alignment::Clustalw'

RUN git clone http://github.com/boutroslab/Supplemental-Material.git /tmp/Supplemental-Material
RUN cp -r /tmp/Supplemental-Material/Rauscher\&Heigwer_2016/crispr-reannotation /root/
#RUN cp -r /tmp/Supplemental-Material/Rauscher\&Heigwer_2016/crispr-reannotation/rennotate_crispr.pl /opt/reannotate_crispr.pl
#RUN cp -r /tmp/crispr-reannotation /root
RUN chmod +x /root/crispr-reannotation/reannotate_crispr.pl
env PATH /root/crispr-reannotation:$PATH

# cannot remove dir currently because of bug https://github.com/moby/moby/issues/27214
# remove comment if it is fixed on your system
# RUN rm -rf /tmp/Supplemental-Material
# install intervaltree...another dependency for the crispr reannotator
RUN cd /root/crispr-reannotation/depends/Set-IntervalTree-0.10-OD; perl Makefile.PL; make; make test && make install

# download bowtie & bowtie 2 source, we need to build from scratch
# because alpine linux glibc is not binary compatible to gnu libc 
# bowtie is build from (using the official sources)

# RUN cd /tmp; wget https://downloads.sourceforge.net/project/bowtie-bio/bowtie/1.2.1.1/bowtie-1.2.1.1-src.zip; unzip bowtie-1.2.1.1-src.zip; cd bowtie-1.2.1.1; make; cp bowtie bowtie-* /usr/bin;
# RUN cd /tmp; wget https://downloads.sourceforge.net/project/bowtie-bio/bowtie2/2.3.2/bowtie2-2.3.2-source.zip; unzip bowtie2-2.3.2-source.zip; cd bowtie2-2.3.2; make; cp bowtie2 bowtie2-* /usr/bin;

ENV BOWTIE2_VERSION 2.2.8
ENV BOWTIE_VERSION 1.2.2

RUN wget https://downloads.sourceforge.net/project/bowtie-bio/bowtie2/$BOWTIE2_VERSION/bowtie2-$BOWTIE2_VERSION-linux-x86_64.zip \
    && unzip -d /usr/bin bowtie2-$BOWTIE2_VERSION-linux-x86_64.zip
    

RUN wget https://downloads.sourceforge.net/project/bowtie-bio/bowtie/$BOWTIE_VERSION/bowtie-$BOWTIE_VERSION-linux-x86_64.zip \
    && unzip -d /usr/bin bowtie-$BOWTIE_VERSION-linux-x86_64.zip \
    && chmod -R a+rwx /usr/bin/bowtie* \
    && mv /usr/bin/bowtie2-2.2.8/* /usr/bin/ \
    && mv /usr/bin/bowtie-*/bowtie* /usr/bin/

# deploy E-TALEN/E-CRISPR on nginx
#COPY E-TALEN /var/www/E-TALEN
#COPY E-CRISP /var/www/E-CRISP
COPY etc/lighttpd /etc/lighttpd
COPY cld /var/www/cld
RUN cp /var/www/cld/cld* /usr/bin/


RUN touch /var/log/talecrisp.log
RUN chown lighttpd:lighttpd /var/log/talecrisp.log 

# RUN mkdir -p /var/www/E-CRISP/workdir/buffer
# RUN touch /var/www/E-CRISP/workdir/buffer/buffer.idx
RUN chown lighttpd:lighttpd /var/www -R

# DO SOME DEBUGGING LOGS
#RUN echo 'fastcgi.debug = 1' >> /etc/lighttpd/mod_fastcgi.conf 

WORKDIR /var/www
EXPOSE 80
ENV LANG en-US

COPY local.conf /etc/fonts/local.conf


RUN chmod -R a+rwx /usr/bin/cld*

#ENTRYPOINT ["/docker-entrypoint.sh"]
## finally run
#CMD ["start-app"]
