#!/bin/bash

        # Purpose: Remote Procedure Call Interface For Smoke.io
        # Scripter: Relaylogix
        # Contact: http://smoke.io/@relaylogix

        # Clear Output Window

        printf "\f"

        # Included Global Script Librarys

. ./l0g1x.lib
. ./rnd_cmt.func
. ./witness.func

        # Local Script Functions

        # Local Declarations

read_config

        # Interface Title Banner

        printf "${green}kief-tools Smoke.io RPC Interface Loaded...\nCreated By:${red} @relaylogix\n${green}http://smoke.io/@relaylogix\n\n${blue}"
        printf "For help please reachout to me on the Smoke Network Discord channel.\nOr visit the kief-tools discord channel @ https://discord.gg/JQtFQ8\n${white}"

        # Check config active user file exists-if not clear config variable
        [ -f "${ACTIVES}" ] && active_accounts_path=${ACTIVES} || active_accounts_path=""
        # Main Structure Of Script Start

        while :
        do
                # Display User With List Of Commands To Use

                printf "${green}-----==================================================-----\n"
                printf "${green}-----=====[    kief-tools v0.0.1 for SMOKE.io    ]=====-----\n"
                printf "${green}-----==================================================-----\n\n"
                printf "${white}0      Clear Output Window\n1      Setup Config\n1a     Current Config\n2      Add Active User\n"
                printf "2a     Display Active User List\n2b     Generate Random Account From Actives List\n3      Smoke Accounts Count\n4      Registered Witness Count\n4a     List Top Active Witnesses\n"
                printf "4b     Request Current Missed Blocks For Witness\n5      Request Current Smoke Network Hard Fork Version\n6      The @d00k13-Get Comments And Random Comment Author\n"
                printf "x      Exits Interface\n\n       ${green}Current Actives List Path:${red} ${active_accounts_path}\n"
                printf "${red}\n[Type Your Control Selection Number]----->${white}"
                read user_input
                case "$user_input" in
                        0)
                                # Clear Output Screen
                                printf "\f"
                                ;;
                        1)
                                # Current Config Setup
                                printf "${red}Specify Path To Active Accounts File?  ${white}"
                                read active_accounts_path
                                printf "\n${red}Verify Path To Set For Active Accounts Is:${green} ${active_accounts_path}\n"
                                printf "${red}Is This Path Correct? y For Ok, Any Other Key To Cancel.  "
                                read user_ack
                                case "$user_ack" in
                                        y)
                                                touch ${active_accounts_path}
                                                printf "${green}Config Updated!\n\n${white}"
                                                ACTIVES=${active_accounts_path}
                                                write_config
                                                ;;
                                        *)
                                                printf "${red} User Aborted Config Update. Try Again.\n${white}"
                                                active_accounts_path="active.accounts"
                                                ;;
                                esac
                                ;;
                        1a)
                                # Display Current Setup
                                printf "${green}The Current Active Accounts File Is Located At: ${active_accounts_path}\n${white}"
                                ;;
                        2)
                                if [ -f "${active_accounts_path}" ]; then

                                        # Add A User To The Active Users File
                                        printf "${red}Specify User Account To Add To The Active Accounts File:  ${white}"
                                        read active_user
                                        user_on_list "${active_accounts_path}" $active_user
                                        if [ $NAMEFOUND = 0 ]; then
                                                echo $active_user >> "${active_accounts_path}"
                                            printf "${red}"$active_user" has been added to the active users list.\n\n${white}"
                                        else
                                                printf "${red}The account${green} "$active_user"${red} is already on the list. ${green}Add again? (y|n)\n"
                                                read user_ack
                                                if [ $user_ack = "y" ]; then
                                                        echo $active_user >> "${active_accounts_path}"
                                                        printf "${red}"$active_user" has been added to the active users list.\n\n${white}"
                                               fi
                                        fi
                                else
                                        printf "${yel}No active users path has been set. Use option 1 to set an active users file to use.${white}\n\n"
                                        sleep 2
                                fi
                                ;;
                        2a)
                                if [ -f "${active_accounts_path}" ]; then

                                        ret_data=$(cat "$active_accounts_path")
                                        actives_count=$(wc -l "$active_accounts_path")
                                        active_accounts_len=${#active_accounts_path}
                                        clean_string 0 "${active_accounts_len}" "${actives_count}"
                                        sleep 0.25
                                        clean_string 0 1 "$CLEANED_STRING"
                                        printf "${green}There Are Currently${red} ${CLEANED_STRING} ${green}Accounts On The Active List\n"
                                        printf "${red}${ret_data}${white}\n\n"
                                else
                                        printf "${yel}No active users path has been set. Use option 1 to set an active users file to use.${white}\n\n"
                                        sleep 2
                                fi
                                ;;
                        2b)
                                if [ -f "${active_accounts_path}" ]; then

                                        get_weekly_actives "${active_accounts_path}"
                                        printf "\n${red}This weeks active account winner is:${yel} $WEEKLY_ACTIVE${white}\n\n"
                                else
                                        printf "${yel}No active users path has been set. Use option 1 to set an active users file to use.${white}\n\n"
                                        sleep 2
                                fi
                                ;;
                        3)
                                printf "\n\n${green}The current account count on the Smoke Network is...\n"


                                ret_data=``` curl -s --data '{"jsonrpc": "2.0", "method": "get_account_count", "params": [[ ]], "id": 0 }' ${RPCSERVER} ```
                                clean_string 17 1 $ret_data
                                printf "There are currently  ---  ${red}${CLEANED_STRING}${green}  ---  accounts registered on the ${white}SMOKE ${green}blockchain..\n\n${white}"
                                ;;
                        4)
                                printf "\n\n${green}The current number of registered Smoke Network witnesses is...\n${white}"
                                ret_data=``` curl -s --data '{"jsonrpc": "2.0", "method": "get_witness_count", "params": [[ ]], "id": 1 }' ${RPCSERVER} ```
                                clean_string 17 1 $ret_data
                                printf "${green}There are currently  ---  ${red}${CLEANED_STRING}${green}  ---  witness accounts registered on the ${white}SMOKE ${green}blockchain..\n\n${white}"
                                ;;
                        4a)
                                printf "\n\n${green}The current active Smoke Network witnesses are...\n${white}"
                                ret_data=``` curl -s --data '{"jsonrpc": "2.0", "method": "get_active_witnesses", "params": [[ ]], "id": 2 }' ${RPCSERVER} ```
                                clean_string 18 2 $ret_data
                                printf "${green}The current top witnesses are  ---  ${red}${CLEANED_STRING}\n\n${white}"
                                ;;
                        4b)
                                witness_missed_blocks
                                ;;
                        5)
                                ret_data=``` curl -s --data '{"jsonrpc": "2.0", "method": "get_hardfork_version", "params": [[ ]], "id": 3 }' ${RPCSERVER} ```
                                clean_string 18 2 $ret_data
                                printf "${green}The Current Smoke Network Hard Fork Version Is  ---  ${green}${CLEANED_STRING}\n\n${white}"
                                ;;
                        6)
                                # Get Post Comments
                                get_comment_author
                                ;;
                        x)
                                # Close Interface
                                exit 0
                                ;;
                        *)
                                # Un Reckognized Command
                                printf "${red}That command is not reckognized.${white}\n"
                                ;;
                esac
        done
