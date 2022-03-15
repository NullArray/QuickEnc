#!/bin/bash
# +------       +      |                           +----===================+ 
# |      +         .   |     .         |      .     |    |     '       / | |
# | ____   ____        +     __  .     +            |    /__      ___ (  / | 
# | \   \ /   /____   _____/  |_  ___________    .  + |  \\--`-'-|`---\\ | |
# |  \   Y   // __ \_/ ___\   __\/  _ \_  __ \        |   |' _/   ` __/ /  | 
# | | \     /\  ___/\  \___|  | (  <_> )  | \/    .   +  | '._  W    ,--'  |
# | |  \___/  \___  >\___  >__|  \____/|__|              |    |_:_._/   +  | 
# | +        +    \/     \/   --=[IN HOC SIGNO VINCIS]   +           +     | 
# +==========|============ +=====   =================|======+===== ========+ 
############################################################################

ESC="\x1b["
RESET=$ESC"39;49;00m"
RED=$ESC"31;01m"

# Generate random password of arbitrary length
generate(){
    follow_up=$1
    clear && echo -e "Generate Random Password"
    
    echo -e "\nAmount of characters in generated password?"
    read -p "[Integer]: " amount
    
    sleep 0.5 clear 
    
    cat /dev/random | LC_ALL=C tr -dc 'a-zA-Z0-9' | head -c$amount
    
    echo -e "Your randomly generated password is: $amount"
    echo -e "Do not lose it!"
    read -p "Enter any button to resume..." null
   
    if [[ follow_up == "true" ]]; then encode; fi
    
};

# Encoding ops
encode(){
    clear && echo -e "Encode File\n"
    read -p 'File: ' infile
    echo -e 'Password: \n'
    read -s password
    openssl enc -aes256 -e -k $password -pbkdf2 -in '$infile' -out '$infile.enc'
    openssl -a -in $infile -out '$infile.enc.pem'
    
    echo -e "\nDone!\n" && sleep 1.5
    exit 0
    
};

# Decoding ops
decode(){
    clear && echo -e "Decode File\n"
    read -p 'File: ' infile
    echo -e 'Password: \n'
    read -s password
    openssl enc -d -aes256 -k $password -pbkdf2 -in '$infile.enc' -out '$infile.b64'
    read -p 'Outfile format ' outfile
    openssl -a -d -in '$infile.b64' -out $outfile
    
    echo -e "\nDone!\n" && sleep 1.5
    exit 0
};


# Parse CLI
if [[ "$1" != "" ]]; then
    case $1 in
        '-e' | '--encode' )
        encode
    esac

elif [[ "$1" != "" ]]; then
    case $1 in
        '-d' | '--decode' )
        decode
    esac

elif [[ "$1" != "" ]]; then
    case $1 in
        '-g' | '--gen-pass' )
        generate "false"
    esac

elif [[ "$1" == "-e" || "$1"  == "--encode" ]]; then
    if [[ "$1" != "" && "$2" != "" ]]; then
		case $2 in
			'-g' | '--gen-pass' )
			generate "true"
		esac
	fi

else
	clear
	echo -e "\n$RED[!] Unhandled Option$RESET" 
	echo -e "\nThis script expects at least one valid CLI argument." 
	echo -e "./script --encode [-e]"
	echo -e "./script --decode [-d]"
	echo -e "./script --gen-pass [-g]\n"
	
	echo -e "To encode file with a randomly generated password"
	echo -e "please pass the following as command line options:\n"
	
	echo -e "./script --encode [-e] --gen-pass [-g]\n"
	sleep 1 && exit 1
fi
