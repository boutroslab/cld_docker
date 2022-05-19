FROM ubuntu:latest

MAINTAINER Florian Heigwer "f.heigwer@dkfz.de"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
	&& apt-get install -y \
    curl \
    expat \
    gcc \
    git \
    graphviz-dev \
    g++ \
    libcgi-fast-perl \
    libdb-dev \
    libgd-dev \
    libperl-dev \
    libxml2-dev \
    libxt-dev \
    make \ 
    ncbi-blast+ \
    openbox \
    perl \
    perl-debug \ 
    perl-doc \ 
    perl-modules \
    perl-tk \
    pv \
    python3 \
    rsync \
    sudo \
    wget \
    xauth \
    xorg \
    xserver-xorg \
    zlib1g-dev \
    ca-certificates \
    ffmpeg \
    gnupg \
    hicolor-icon-theme \
    libglapi-mesa \
    libosmesa6 \
    libtbb-dev \
    unzip

    
ENV PERL_MM_USE_DEFAULT=1

RUN perl -MCPAN -e 'CPAN::Shell->install("Bundle::CPAN")'
RUN perl -MCPAN -e 'CPAN::Shell->install("FCGI")'
RUN perl -MCPAN -e 'CPAN::Shell->install("Bio::Perl")'
# now install all the modules we need for crispr reannotator
RUN perl -MCPAN -e 'CPAN::Shell->install("Bio::DB::Fasta")'
RUN perl -MCPAN -e 'CPAN::Shell->install("Bio::SeqIO")'
RUN perl -MCPAN -e 'CPAN::Shell->install("Bio::Tools::GFF")'
RUN perl -MCPAN -e 'CPAN::Shell->install("Scalar::Util")'
RUN perl -MCPAN -e 'CPAN::Shell->install("Term::ProgressBar")'
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
RUN perl -MCPAN -e 'CPAN::Shell->install("Timer::Runtime")'

ENV BOWTIE2_VERSION 2.4.5
ENV BOWTIE_VERSION 1.3.1

RUN wget https://downloads.sourceforge.net/project/bowtie-bio/bowtie2/$BOWTIE2_VERSION/bowtie2-$BOWTIE2_VERSION-linux-x86_64.zip \
    && unzip -d /usr/bin bowtie2-$BOWTIE2_VERSION-linux-x86_64.zip
    

RUN wget https://downloads.sourceforge.net/project/bowtie-bio/bowtie/$BOWTIE_VERSION/bowtie-$BOWTIE_VERSION-linux-x86_64.zip \
    && unzip -d /usr/bin bowtie-$BOWTIE_VERSION-linux-x86_64.zip \
    && chmod -R a+rwx /usr/bin/bowtie* \
    && mv /usr/bin/bowtie2*/* /usr/bin/ \
    && mv /usr/bin/bowtie*/bowtie* /usr/bin/

COPY etc/cld /var/www/cld 

RUN cp /var/www/cld/cld* /usr/bin/

RUN cd /var/www/cld/depends/Set-IntervalTree-0.10-OD; perl Makefile.PL; make; make test && make install

WORKDIR /var/www

ENV LANG en-US
ENV LANGUAGE="en_US.UTF-8"
ENV LC_ALL="C"

COPY local.conf /etc/fonts/local.conf

RUN chmod -R a+rwx /usr/bin/cld*
