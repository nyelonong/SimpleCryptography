#!usr/bin/perl
use strict;
use warnings;
use File::Slurp;

if ($#ARGV != 3 ) {
	print "usage: sicry.pl -e/-d input key output\neg: sicry.pl -e plain.txt iamakey encrypted.txt\n";
	exit;
}

my $rcm = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 \n";
my $com = "SpXiO7sIaNJtjD2oWwqRf1M8ubGeCgyKLzdPh5V3cAv64FnQxl ZBU90rHkTYmE\n";

my $op = $ARGV[0];
my $input = $ARGV[1];
my $key = $ARGV[2];
my $output = $ARGV[3];

my @arrRCM = $rcm =~ /./sg;
my @arrCOM = $com =~ /./sg;
my $sizeRCM = @arrRCM;

if($op eq "-e"){
	my @arrEncrypted;

	$key =~ s/(.)(?=.*?\1)//g;
	my @arrKey = $key =~ /./sg;
	
	my $plain = read_file($input);
	my @arrPlain = $plain =~ /./sg;
	my $sizePlain = @arrPlain;
	
	my $sizeKey = @arrKey;
	my @arrMap;
	
	foreach my $x (@arrKey){
    		push(@arrMap, $x);
	}
	
	for(my $i=$sizeKey; $i<64; $i++){
		my $a;
		my $b;
		my $flag = 0;
			
		for(my $j=0; $j<$sizeKey; $j++){
			if($flag == 1){
				$b = $a;		
			}else{
				$b = $arrCOM[$i];
			}
			
			if($b eq $arrMap[$j]){
				$a = $arrCOM[$j];
				$flag = 1;
			}	
		}
		if($flag == 1){
			push(@arrMap, $a);	
		}else{
			push(@arrMap, $arrCOM[$i]);
		}
	}
	
	for(my $i=0; $i<$sizePlain; $i++){
		for(my $j=0; $j<$sizeRCM; $j++){
			if($arrPlain[$i] eq $arrRCM[$j]){
				push(@arrEncrypted, $arrMap[$j]);
			}
		}
	}
	
	
	my $encrypted = join('',@arrEncrypted);
	write_file($output, $encrypted);
	print "File $input successfully encrypted to $output\n";
}

exit 0;
