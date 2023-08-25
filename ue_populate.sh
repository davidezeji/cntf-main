#!usr/bin/env bash

# open5gs-dbctl add_ue_with_slice 0000000001 465B5CE8B199B49FAA5F0A2EE238A6BC E8ED289DEBA952E4283B54E88E6183CA internet 1 111111

generate_random_imsi() {   
     digits=10    
     current_time=$(date +%s)    
     random_number=$((current_time * (1 + RANDOM % 10000)))    
     while [ ${#random_number} -lt 12 ]; do       
         random_number="${random_number}$(shuf -i 0-9 -n 1)"    
     done   

    imsi_id="${random_number:0:digits}"    
    echo $imsi_id}
}

open5gs-dbctl add_ue_with_slice (generate_random_imsi) 465B5CE8B199B49FAA5F0A2EE238A6BC E8ED289DEBA952E4283B54E88E6183CA internet 1 111111
