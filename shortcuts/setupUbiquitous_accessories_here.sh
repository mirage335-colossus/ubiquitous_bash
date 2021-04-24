
# ATTENTION: Override with 'ops.sh' , 'core.sh' , or similar.
_setupUbiquitous_accessories_here-gnuoctave() {
	cat << CZXWXcRMTo8EmM8i4d

tera = 10^12
giga = 10^9
mega = 10^6
kilo = 10^3

bit = 1
byte = 8

terabit = tera
gigabit = giga
megabit = mega
kilobit = kilo

Tb = tera
Gb = giga
Mb = mega
Kb = kilo

terabyte = terabit * byte
gigabyte = gigabit * byte
megabyte = megabit * byte
kilobyte = kilobit * byte

TB = terabyte
GB = gigabyte
MB = megabyte
KB = kilobyte


pkg load symbolic

syms a b c d e f g h i j k l m n o p q r s t u v w x y z


unix("true")
system("true")

cd

# Equivalent to Ctrl-L . 
# https://stackoverflow.com/questions/11269571/how-to-clear-the-command-line-in-octave
clc




CZXWXcRMTo8EmM8i4d
}

