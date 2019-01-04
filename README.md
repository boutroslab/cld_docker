# fetch binary dependencies before running docker build
wget bowtie2-2.2.9-linux-x86_64.zip, bowtie-1.2-linux-x86_64.zip
# fetch E-TALEN and E-CRISPR dirs from hidden repo or Webserver
# e.g.
EXCL_STRING='--exclude=E-CRISP/workdir/Mon* --exclude=E-TALEN/workdir/Mon*'
for i in E-CRISP E-TALEN
do
  for j in "$i/workdir/boutros_benchmark*" "$i/workdir/Tue*" "$i/workdir/Wed*" "$i/workdir/Thu*" "$i/workdir/Fri*" "$i/workdir/Sat*" "$i/workdir/Sun*"
    do
      EXCL_STRING=$EXCL_STRING" --exclude="$j
  done
done
rsync -rav b110-ws01@b110-ws01:/var/www/E-* . --progress $EXCL_STRING
# prepare 
rm  E-CRISP/workdir/buffer/buffer.idx
touch E-CRISP/workdir/buffer/buffer.idx

# fix some relative path problems
cd E-CRISP/workdir
sed -i.bak 's#src="\([a-zA-Z]\)#"src="/E-CRISP/\1#g' *.txt
sed -i.bak 's#src="../\([a-zA-Z]\)#src="/E-CRISP/workdir/\1#g' *.txt
sed -i.bak 's#"../../#"/E-CRISP/#g' *.txt
cd ../../E-TALEN/workdir
sed -i.bak 's#src="\([a-zA-Z]\)#"src="/E-TALEN/\1#g' *.txt
sed -i.bak 's#src="../\([a-zA-Z]\)#src="/E-TALEN/workdir/\1#g' *.txt
sed -i.bak 's#"../../#"/E-TALEN/#g' *.txt

sed -i.bak 's#"/SVGPan.js#/E-TALEN/SVGPan.js#g' E-TALEN/make_tales_ng_waitpage.pl

# for testing on testserver e.g. cellarray4 run the following (not on producton)
find . -name '*.js' -or -name '*.html' -exec sed -i.bak 's#www.e-crispr.org#b110-cellarray4#g'  {} \;


# next you need to transfer databasefiles dirs to your machine or later link them using -v into docker image '/data/DATABASEFILES/' dir
# for example if you want to work with homo sapiens and drosophila use
rsync -rav b110-ws01@b110-ws01:/data/DATABASEFILES/drosophila_melanogaster databasefiles --progress
rsync -rav b110-ws01@b110-ws01:/data/DATABASEFILES/homo_sapiens databasefiles --progress
# or transfer all organisms which will be > 300 GB files
rsync -rav b110-ws01@b110-ws01:/data/DATABASEFILES/ databasefiles --progress
# start with something like
docker run -v /home/schmidte/e-talen-dockerfile/databasefiles:/data/DATABASEFILES -p 80:80 <IMAGEID>
