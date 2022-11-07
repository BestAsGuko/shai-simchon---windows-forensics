#the first function MEM is for memory analysis, first,it create 'mem' directory that puts the output log inside, then it gets the windows os profile and then is scan psscan to check if it was any suspicious processes in the system.
function MEM()
{
mkdir mem;
a=$(./volatility_2 imageinfo -f $1 | grep Profile | awk '{print $4}'  | cut -d',' -f1) ;
./volatility_2 --profile=$a psscan -f $1 > mem/mem.txt
}

#the second function HDD scan and extract important files from hdd image file like email addresses, credit card numbers, JPEGs and JSON snippets and etc and puts the output in 'hdd' directory.
function HDD()
{
bulk_extractor $1 -o hdd
}

#the third fumction LOG create and represent the results and statistics of the process was selected in the arguments field of the script..
function LOG()
{
if [ $1 = 'mem' ]
then
(cat mem/mem.txt; echo total files in psscan memory file is:;awk 'NR>2' mem/mem.txt | wc -l)>mem/memlog.txt;
cat mem/memlog.txt

elif [ $1 = 'hdd' ]
then
(ls hdd) > hdd/hddlog.txt; (echo; echo total files from bulk_extractor operation is:;cat hdd/hddlog.txt | wc -l) >> hdd/hddlog.txt; echo >> hdd/hddlog.txt; echo total emails from bulk_extractor operation: >> hdd/hddlog.txt ;(cat hdd/email.txt | awk 'NR>5' | wc -l ) >> hdd/hddlog.txt;
cat hdd/hddlog.txt
fi
}

#if user enter the word 'mem' in the first argument (before choosing the file to be analyzed) the MEM function will run.
#if user enter the word 'hdd' in the first argument (before choosing the file to be analyzed) the HDD function will run.
if [ $1 = 'mem' ]
then
MEM $2

elif [ $1 = 'hdd' ]
then
HDD $2

else
echo 'you didnt fill the requierd arguuments'
fi

LOG $1
