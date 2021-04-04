#!/bin/bash

L=0 #STDIN

field1=( "_" "|" "_" "|" "_" )
field2=( "_" "|" "_" "|" "_" )
field3=( " " "|" " " "|" " " )

IFS=' '

function check_win() {
        if [[ (${field1[0]} == $maincell && ${field1[2]} == $maincell && ${field1[4]} == $maincell) || #победа по первой линии
                ${field2[0]} == $maincell && ${field2[2]} == $maincell && ${field2[4]} == $maincell || #победа по второй линии
                ${field3[0]} == $maincell && ${field3[2]} == $maincell && ${field3[4]} == $maincell || #победа по третьей линии
                ${field1[0]} == $maincell && ${field2[2]} == $maincell && ${field3[4]} == $maincell || #победа по диагонали 1
                ${field3[0]} == $maincell && ${field2[2]} == $maincell && ${field1[4]} == $maincell || #победа по диагонали 2
                ${field1[0]} == $maincell && ${field2[0]} == $maincell && ${field3[0]} == $maincell || #победа по первой вертикальной линии
                ${field1[2]} == $maincell && ${field2[2]} == $maincell && ${field3[2]} == $maincell || #по второй
                ${field1[4]} == $maincell && ${field2[4]} == $maincell && ${field3[4]} == $maincell ]] #по третьей
        then
                echo "Ты победил"
                echo "exit" > tic_tac_pipe
                rm tic_tac_pipe
                exit 0
        fi
}

if [[ -e tic_tac_pipe ]]
then
        maincell="O"
        movend=true
else
        mknod tic_tac_pipe p
        maincell="X"
        movend=false
fi

while true
do
        clear
        printf %s "${field1[@]}" $'\n'
        printf %s "${field2[@]}" $'\n'
        printf %s "${field3[@]}" $'\n'

        if "$movend"
        then
                echo "Ход противника"
                read -a strarr <<< $( cat tic_tac_pipe )
                if [[ $strarr == "exit" ]]
                then
                        break
                fi
                movend=false

                if [[ $maincell = "X" ]]
                then
                        cell="O"
                else
                        cell="X"
                fi
        elif true
        then
                echo "Ваш ход"
                read L
                if [[ $L == "exit" ]]
                then
                        echo "$L" > tic_tac_pipe
                        rm tic_tac_pipe
                        break
                fi
                read -a strarr <<< "$L" #делим ввод по IFS
                movend=true
                cell=$maincell
        fi

        let "column=(${strarr[1]} - 1) * 2"

        if [[ ${strarr[0]} == "1" && ${field1["$column"]} == "_" ]]
        then
                field1["$column"]="$cell"
        elif [[ ${strarr[0]} == "2" && ${field2["$column"]} == "_" ]]
        then
                field2["$column"]="$cell"
        elif [[ ${strarr[0]} == "3" && ${field3["$column"]} == " " ]]
        then
                field3["$column"]="$cell"
        elif true
        then
                movend=false #была ошибка в воде координат
                continue
        fi

        check_win

        if "$movend"
        then
                echo "$L" > tic_tac_pipe
        fi
done