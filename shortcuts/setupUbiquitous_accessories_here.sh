
# ATTENTION: Override with 'ops.sh' , 'core.sh' , or similar.
_setupUbiquitous_accessories_here-gnuoctave() {
	cat << CZXWXcRMTo8EmM8i4d

%# https://stackoverflow.com/questions/8260619/how-can-i-suppress-the-output-of-a-command-in-octave
%# oldpager = PAGER('/dev/null');
%# oldpso = page_screen_output(1);
%# oldpoi = page_output_immediately(1);

tera = 10^12;
giga = 10^9;
mega = 10^6;
kilo = 10^3;

bit = 1;
byte = 8;

terabit = tera;
gigabit = giga;
megabit = mega;
kilobit = kilo;

Tb = tera;
Gb = giga;
Mb = mega;
Kb = kilo;

terabyte = terabit * byte;
gigabyte = gigabit * byte;
megabyte = megabit * byte;
kilobyte = kilobit * byte;

TB = terabyte;
GB = gigabyte;
MB = megabyte;
KB = kilobyte;


pkg load symbolic;

syms a b c d e f g h i j k l m n o p q r s t u v w x y z;


unix("true");
system("true");

cd;

%# Equivalent to Ctrl-L . 
%# https://stackoverflow.com/questions/11269571/how-to-clear-the-command-line-in-octave
clc;


%# PAGER(oldpager);
%# page_screen_output(oldpso);
%# page_output_immediately(oldpoi);

CZXWXcRMTo8EmM8i4d
}


_setupUbiquitous_accessories_here-gnuoctave_hook() {
	cat << CZXWXcRMTo8EmM8i4d

%# oldpager = PAGER('/dev/null');
%# oldpso = page_screen_output(1);
%# oldpoi = page_output_immediately(1);

%# ubcore
run("$ubcore_accessoriesFile_gnuoctave_ubhome");

%# PAGER(oldpager);
%# page_screen_output(oldpso);
%# page_output_immediately(oldpoi);

CZXWXcRMTo8EmM8i4d
}


