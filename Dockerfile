FROM sebp/lighttpd

MAINTAINER Florian Heigwer "f.heigwer@dkfz.de"

# RUN wget http://dl-cdn.alpinelinux.org/alpine/v3.4/main/x86_64/APKINDEX.tar.gz

RUN \
    apk add --update --no-cache \
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
	gnupg \	
	mesa-gl \
	chromium \
	ca-certificates \
	ffmpeg \
	hicolor-icon-theme \
    db-dev
  # needed for bowtie2
RUN \
    apk --no-cache add --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ \
    libtbb libtbb-dev 
  #  gdebi && rm -rf /var/lib/apt/lists/*
RUN \
     rm -rf /var/cache/apk/*


# now install the reannotate-crispr PERL package
# for CPAN to auto say yes to every question
ENV PERL_MM_USE_DEFAULT=1
RUN perl -MCPAN -e 'CPAN::Shell->install("Bundle::CPAN")'
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


bowtie-1.2.1.1-src.zip; unzip bowtie-1.2.1.1-src.zip; cd bowtie-1.2.1.1; make; cp bowtie bowtie-* /usr/bin;

bowtie2-2.3.2-source.zip; unzip bowtie2-2.3.2-source.zip; cd bowtie2-2.3.2; make; cp bowtie2 bowtie2-* /usr/bin;

ENV BOWTIE2_VERSION 2.2.8
ENV BOWTIE_VERSION 1.2.2

RUN wget https://downloads.sourceforge.net/project/bowtie-bio/bowtie2/$BOWTIE2_VERSION/bowtie2-$BOWTIE2_VERSION-linux-x86_64.zip \
    && unzip -d /usr/bin bowtie2-$BOWTIE2_VERSION-linux-x86_64.zip
    

RUN wget https://downloads.sourceforge.net/project/bowtie-bio/bowtie/$BOWTIE_VERSION/bowtie-$BOWTIE_VERSION-linux-x86_64.zip \
    && unzip -d /usr/bin bowtie-$BOWTIE_VERSION-linux-x86_64.zip \
    && chmod -R a+rwx /usr/bin/bowtie* \
    && mv /usr/bin/bowtie2-2.2.8/* /usr/bin/ \
    && mv /usr/bin/bowtie-*/bowtie* /usr/bin/

COPY etc/cld /var/www/cld

RUN cp /var/www/cld/cld* /usr/bin/

RUN cd /var/www/cld/depends/Set-IntervalTree-0.10-OD; perl Makefile.PL; make; make test && make install

RUN touch /var/log/talecrisp.log
RUN chown lighttpd:lighttpd /var/log/talecrisp.log 

RUN chown lighttpd:lighttpd /var/www -R

WORKDIR /var/www

ENV LANG en-US

COPY local.conf /etc/fonts/local.conf

RUN chmod -R a+rwx /usr/bin/cld*
