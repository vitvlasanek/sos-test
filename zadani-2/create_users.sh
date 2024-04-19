#!/bin/bash
users_count=100

heslo=""
if [ $# -eq 1 ]; then
  if [ ${#1} -lt 6 ];then
        echo "heslo musi byt delsi nez 6"
        exit 1
  fi
  heslo="$1"
fi

for i in $(seq 1 $users_count); do
    if [[ $i -lt 10 ]]
    then
        zero="0"
    else
        zero=""
    fi
    user="user$zero$i"
    echo $user
    echo $heslo
        if [ ${#heslo} -lt 6 ]; then
                useradd -m -p "" $user
                passwd -e $user -q
        else

            useradd -m -s /bin/bash -c "Uzivatel" -p $(echo $heslo |>        fi
        edquota -p franta $user
done


