#!/bin/bash
############################################################################## 
#                                                                            #
#	SHELL: !/bin/bash       version 1	                                     #
#									                                         #
#	NOM: u2pitchjami						                                 #
#									                                         #
#							  					                             #
#									                                         #
#	DATE: 15/12/2024	           				                             #
#									                                         #
#	BUT: Script pour nettoyer logs et sav                 		             #
#									                                         #
############################################################################## 

#définition des variables
SCRIPT_DIR=$(dirname "$(realpath "$0")")
source ${SCRIPT_DIR}/.config.cfg

if [ ! -d $DOSLOG ]; then
    mkdir $DOSLOG
fi

NBLIGNES=$(cat "${BASE_CSV}" | wc -l)
#NBLIGNES=$(expr $NBLIGNES - 1 )
echo -e "${BIGTITRE}[`date`] - Démarrage du scripts clean_logs ${NC}" | tee -a "${LOG}"
echo -e "${PURPLE}$NBLIGNES lignes à traiter ${NC}" | tee -a $LOG

for ((b=2 ;b<=$NBLIGNES ;b++))
do
    NAME=$(cat ${BASE_CSV} |  head -$b | tail +$b | cut -d ";" -f1 )
    CHEMIN=$(cat ${BASE_CSV} |  head -$b | tail +$b | cut -d ";" -f2 )
    FILE=$(cat ${BASE_CSV} |  head -$b | tail +$b | cut -d ";" -f3 )
    HOW=$(cat ${BASE_CSV} |  head -$b | tail +$b | cut -d ";" -f4 )
    NBFILESSUPP=$(find "${CHEMIN}" -type f -iname "${FILE}" | sort -n | head -n -$HOW | wc -l )

    echo -e "${TITRE}[`date`] - Traitement de ${NAME} : ${NBFILESSUPP} fichiers${NC}" | tee -a "${LOG}"
    if [[ $NBFILESSUPP -gt "0" ]]; then
        find "${CHEMIN}" -type f -iname "${FILE}" -print | sort -n | head -n -$HOW | xargs -0 -d '\n' rm -f
        if [[ $? -eq "0" ]]; then
            echo -e "${GREEN}Suppression réalisée${NC}" | tee -a "${LOG}"
        else
            echo -e "${BOLD}${RED}ECHEC de la suppression ${NC}" | tee -a "${LOG}"
        fi
    else
        echo -e "${PURPLE}Rien à Supprimer, élément suivant...${NC}" | tee -a "${LOG}"
    fi
done

echo -e "${TITRE}[`date`] - C'est fini, bisous ${NC}" | tee -a "${LOG}"