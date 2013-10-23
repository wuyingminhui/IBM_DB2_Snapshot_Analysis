#Transfer snapshot.txt to stmt.txt


use strict;
use IO::File;
use Time::Local;

#Open the snapshot.txt
unless (open(FILE1,$ARGV[0])){
die ("Please enter the snapshot.txt\n");
}

my $date;
my $line;
my @array;
my $ComputerEnv;
my $DBname;
my $firstconnect;
my $reset;
my $snapshottime;
my $dynamic_attempts;
my $statics_attempts;
my $commit;
my $rollback;
my $Others;
my $sqlselected;
my $sqlUPdateInsertDelete;
my $sqlread_write;
my $Rowsread;
my $Rowsselected;
my $select_ratio;
my $lockwaittime;
my $lockwait;
my $averagelocktime;
my $Totalsort;
my $Totalsorttime;
my $averagesorttime;
my $sortoverflows;
my $package_inserts;
my $package_lookups;
my $PCHR;
my $catalog_inserts;
my $catalog_lookups;
my $CCHR;
my $BPDLR;
my $BPDPR;
my $BPILR;
my $BPIPR;
my $BPRatio;
my $position;

#Show start time.
$date=localtime(time);
print "Start from ".$date;

#Write the tag to the txt.
open (OUTFILE, ">>DB2_Summary.txt");

#Close the file handle.
close(OUTFILE);
print("\nBegin to transfer,please wait!\n");

#Read the data from snapshot.txt.
while($line = <FILE1>)
{
	if($line=~/Operating\ssystem\srunning\sat\sdatabase\sserver/){
		$ComputerEnv=$line;
		$position=index($ComputerEnv,"=");
		$ComputerEnv=substr($ComputerEnv,$position+1,);	
		$ComputerEnv=~s/\n//g;
	}
	if($line=~/Database\sname/){
		$DBname=$line;
		$position=index($DBname,"=");
		$DBname=substr($DBname,$position+2,);
		$DBname=~s/\n//g;
		
	}	
	if($line=~/First\sdatabase\sconnect\stimestamp/){
		$firstconnect=$line;
		$position=index($firstconnect,"=");
		$firstconnect=substr($firstconnect,$position+2,);
		$firstconnect=~s/\n//g;
	}
	if($line=~/Last\sreset\stimestamp/){
		$reset=$line;
		$position=index($reset,"=");
		$reset=substr($reset,$position+2,);
		$reset=~s/\n//g;
	}
	if($line=~/Snapshot\stimestamp/){
		$snapshottime=$line;
		$position=index($snapshottime,"=");
		$snapshottime=substr($snapshottime,$position+2,);
		$snapshottime=~s/\n//g;
	}
	if($line=~/Dynamic\sstatements\sattempte/){
		$dynamic_attempts=$line;
		$position=index($dynamic_attempts,"=");
		$dynamic_attempts=substr($dynamic_attempts,$position+2,);
		$dynamic_attempts=~s/\n//g;
	}
	if($line=~/Commit\sstatements\sattempte/){
		$commit=$line;
		$position=index($commit,"=");
		$commit=substr($commit,$position+2,);
		$commit=~s/\n//g;
	}
	if($line=~/Rollback\sstatements\sattempted/){
		$rollback=$line;
		$position=index($rollback,"=");
		$rollback=substr($rollback,$position+2,);
		$rollback=~s/\n//g;
	}
	if($line=~/Static\sstatements\sattempted/){
		$statics_attempts=$line;
		$position=index($statics_attempts,"=");	
		$statics_attempts=substr($statics_attempts,$position+2,);
		$statics_attempts=~s/\n//g;
		$Others= ($statics_attempts-$commit-$rollback);
	}
	if($line=~/Select\sSQL\sstatements\sexecuted/){
		$sqlselected=$line;
		$position=index($sqlselected,"=");
		$sqlselected=substr($sqlselected,$position+2,);
		$sqlselected=~s/\n//g;
	}
	if($line=~/Update\/Insert\/Delete\sstatements\sexecute/){
		$sqlUPdateInsertDelete=$line;	
		$position=index($sqlUPdateInsertDelete,"=");
		$sqlUPdateInsertDelete=substr($sqlUPdateInsertDelete,$position+2,);
		$sqlUPdateInsertDelete=~s/\n//g;
	}
	if($line=~/Rows\sread/){
		$Rowsread=$line;
		$position=index($Rowsread,"=");
		$Rowsread=substr($Rowsread,$position+2,);
		$Rowsread=~s/\n//g;
		if($Rowsread=="0"||$Rowsselected=="0"){
			$select_ratio=0;
		}else{
			$select_ratio=sprintf("%.5f", ($Rowsread)/($Rowsselected));
		}
	}
	if($line=~/Rows\sselected/){
		$Rowsselected=$line;	
		$position=index($Rowsselected,"=");
		$Rowsselected=substr($Rowsselected,$position+2,);
		$Rowsselected=~s/\n//g;
	}
	if($line=~/Time\sdatabase\swaited\son\slocks/){
		$lockwaittime=$line;	
		$position=index($lockwaittime,"=");
		$lockwaittime=substr($lockwaittime,$position+2,);
		$lockwaittime=~s/\s//g;
		if($lockwaittime=="0"||$lockwait=="0"){
			$averagelocktime=0;
		}else{
			$averagelocktime=sprintf("%.5f", ($lockwaittime)/($lockwait));
		}
	}
	if($line=~/Lock\swaits/){
		$lockwait=$line;	
		$position=index($lockwait,"=");
		$lockwait=substr($lockwait,$position+1,);
		$lockwait=~s/\s//g;
	}	
	if($line=~/Total\ssorts/){
		$Totalsort=$line;	
		$position=index($Totalsort,"=");
		$Totalsort=substr($Totalsort,$position+1,);
		$Totalsort=~s/\s//g;
	}
	if($line=~/Total\ssort\stime/){
		$Totalsorttime=$line;	
		$position=index($Totalsorttime,"=");
		$Totalsorttime=substr($Totalsorttime,$position+1,);
		$Totalsorttime=~s/\s//g;
		if($Totalsorttime=="0"||$Totalsort=="0"){
			$averagesorttime=0;
		}else{
			$averagesorttime=sprintf("%.5f", ($Totalsorttime)/($Totalsort));
		}
	}
	if($line=~/Sort\soverflows/){
		$sortoverflows=$line;	
		$position=index($sortoverflows,"=");
		$sortoverflows=substr($sortoverflows,$position+1,);
		$sortoverflows=~s/\s//g;
		if($sortoverflows=="0"||$Totalsort=="0"){
			$sortoverflows=0;
		}else{
			$sortoverflows=sprintf("%.5f", ($sortoverflows)/($Totalsort)*100);
		}
	}
	if($line=~/Package\scache\sinserts/){
		$package_inserts=$line;	
		$position=index($package_inserts,"=");
		$package_inserts=substr($package_inserts,$position+2,);
		$package_inserts=~s/\s//g;
		$PCHR=(1-(($package_inserts)/($package_lookups)))*100;
	}
	if($line=~/Package\scache\slookups/){
		$package_lookups=$line;	
		$position=index($package_lookups,"=");
		$package_lookups=substr($package_lookups,$position+2,);
	}
	if($line=~/Catalog\scache\sinserts/){
		$catalog_inserts=$line;	
		$position=index($catalog_inserts,"=");
		$catalog_inserts=substr($catalog_inserts,$position+2,);
		$catalog_inserts=~s/\s//g;
		$CCHR=(1-(($catalog_inserts)/($catalog_lookups)))*100;
	}
	if($line=~/Catalog\scache\slookups/){
		$catalog_lookups=$line;	
		$position=index($catalog_lookups,"=");
		$catalog_lookups=substr($catalog_lookups,$position+2,);
	}
	if($line=~/Buffer\spool\sdata\slogical\sreads/){
		$BPDLR=$line;	
		$position=index($BPDLR,"=");
		$BPDLR=substr($BPDLR,$position+1,);
		$BPDLR=~s/\s//g;
	}
	if($line=~/Buffer\spool\sdata\sphysical\sreads/){
		$BPDPR=$line;	
		$position=index($BPDPR,"=");
		$BPDPR=substr($BPDPR,$position+1,);
		$BPDPR=~s/\s//g;
		#print $BPDPR;
	}
	if($line=~/Buffer\spool\sindex\slogical\sreads/){
		$BPILR=$line;	
		$position=index($BPILR,"=");
		$BPILR=substr($BPILR,$position+1,);
		$BPILR=~s/\s//g;
		#print $BPILR;
	}	
	if($line=~/Buffer\spool\sindex\sphysical\sreads/){
		$BPIPR=$line;	
		$position=index($BPIPR,"=");
		$BPIPR=substr($BPIPR,$position+1,);
		$BPIPR=~s/\s//g;
		if(($BPDLR+$BPILR)==0||($BPIPR+$BPDPR)==0){
			$BPRatio=100;
		}else{
			$BPRatio = (1-($BPIPR+$BPDPR)/($BPDLR+$BPILR))*100;
		}
	}
     	if($line=~/Bufferpool\sSnapshot/){
	open (OUTFILE, ">>DB2_Summary.txt");
	print OUTFILE ("Operating system running at database server: ".$ComputerEnv."\n");  
	print OUTFILE ("DB name: ".$DBname."\n"."First Connect Time: ".$firstconnect."         Reset Time: ".$reset."        Snapshot Time".$snapshottime."\n");
	print OUTFILE ("Dynamic executions:   ".$dynamic_attempts."\n");
	print OUTFILE ("Static executions:    ".$statics_attempts."  (Commit ".$commit." , Rollback ".$rollback." , Other ".$Others.")"."\n");
	print OUTFILE ("SQL select: ".$sqlselected."     SQL Update/Insert/Delete: ".$sqlUPdateInsertDelete."\n"); 
	print OUTFILE ("Rows Read/Rows Selected ratio= ".$select_ratio."\n");
	print OUTFILE ("Average Lock Wait time= ".$averagelocktime." ms"."\n");
	print OUTFILE ("Average Sort time=".$averagesorttime." ms".", Sort Oflo= ".$sortoverflows." %"."\n");
	print OUTFILE ("Package Cache hit rate= ".$PCHR." %"."\n"."Catalog Cache hit rate= ".$CCHR." %"."\n");
	print OUTFILE ("Overall bufferpool hit rate: ".$BPRatio." %"."\n");
	last;
	}
	
}

#Show end time.
$date=localtime(time);
print "End at ".$date;

#Close the file handle.
close(OUTFILE);
close(FILE1)
