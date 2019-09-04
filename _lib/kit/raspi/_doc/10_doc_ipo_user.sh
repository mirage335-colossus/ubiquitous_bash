# ATTENTION: Syntax highlighted documentation. Description of typical [Input]-[Process]-[Output] (IPO) .


# INPUT - USER
_INPUT_COMMENT() {

# "$1" == current_username
# stdin = password
#_custom_construct_user() { }

"$scriptLocal"/ssh_pub_"$current_username"/*.pub

"$scriptLocal"/_custom/crontab				# Typically deleted at start of '_custom' .

}

# OUTPUT - USER
_OUTPUT_COMMENT() {

"$globalVirtFS"/home/"$current_username"/.ssh/authorized_keys

crontab -u "$custom_user"

}




































































































