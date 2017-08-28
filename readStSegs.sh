stseg_fldr="$1"
echo $stseg_fldr
files=$(find "$stseg_fldr/" -name "*.stseg")
for f in $files
do
	echo "CONVERTING: "$f
	cat $f | ./stseg-read > $f.txt
done
