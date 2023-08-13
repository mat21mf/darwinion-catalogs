
  declare -gx EnlacePagina="http:\/\/www2.darwin.edu.ar"
  declare -gx FiltroIndice="div.container:nth-child(2) > a               attr{href}"
  declare -gx FiltroTablaI="div.container:nth-child(2) > div:nth-child(36) > table:nth-child(1) > tbody:nth-child(1) > tr > td > a attr{href}"
  declare -gx FiltroEnlace="div.container:nth-child(2) > div:nth-child(36) > table:nth-child(1) > tbody:nth-child(1) > tr              > td:nth-child(1) > a              attr{href}"
  declare -gx FiltroNombre="div.container:nth-child(2) > div:nth-child(36) > table:nth-child(1) > tbody:nth-child(1) > tr              > td:nth-child(1) > a              text{}"
  declare -gx FiltroDescri="div.container:nth-child(2) > div:nth-child(36) > table:nth-child(1) > tbody:nth-child(1) > tr              > td:nth-child(2) text{}"
 ## Desde tr:nth-child(2) hasta el ultimo de cada enlace
 #declare -gx FiltroJson01="div.container:nth-child(2) > div:nth-child(36) > table:nth-child(1) > tbody:nth-child(1) > tr:nth-child(2) > td              json{}"
  declare -gx FiltroJson01="div.container:nth-child(2) > div:nth-child(36) > table:nth-child(1) > tbody:nth-child(1) > tr:nth-child(2) > td              json{}"
  declare -gx FiltroIndiceAutogen="
        pup "${FiltroIndice}" \
      | sed -r 's/(.*)/wget -c '"${EnlacePagina}"'\1/' \
      | sed -r 's/(.*)\?(.*)/\1?\2 -O html\/\2\.html/' \
      | sed -r 's/(.*)=/\1_/' \
      "
  declare -gx FiltroJqIndice="
        jq '.
          | {
            col_01_codigo      : .[0].children[0].href | split(\";\")[5] | split(\"=\")[1]                   ,
            col_02_subenlace   : .[0].children[0].href                                                       ,
            col_03_titulo      : .[0].children[0].text                                                       ,
            col_04_descripcion : .[1].text                                                                   ,
            col_05_genero      : .[0].children[0].href | split(\";\")[4] | split(\"=\")[1] | split(\"&\")[0] ,
            col_06_especie     : .[0].children[0].href | split(\";\")[3] | split(\"=\")[1] | split(\"&\")[0] ,
            col_07_subespecie  : .[0].children[0].href | split(\";\")[2] | split(\"=\")[1] | split(\"&\")[0] ,
            col_08_variedad    : .[0].children[0].href | split(\";\")[1] | split(\"=\")[1] | split(\"&\")[0] ,
            col_09_forma       : .[0].children[0].href | split(\";\")[0] | split(\"=\")[1] | split(\"&\")[0]
            }'
            "

  declare -gx FiltroJqAColumnas="
        jq -s -r '(map(keys) | add | unique) as \$cols | map(. as \$row | \$cols | map(\$row[.])) as \$rows | \$cols, \$rows[] | @tsv'
      "
  declare -gx FiltroOrdenaColumnas="
        sed -r '1s/col_[0-9]{2}_//g;1s/subenlace/enlace/'
    "

  function DescargarDarwinionIndice ()
  {
    cat "${1}" \
      | pup "${FiltroIndice}" \
      | sed -r 's/(.*)/wget -c '"${EnlacePagina}"'\1/' \
      | sed -r 's/(.*)\?(.*)/\1?\2 -O html\/\2\.html/' \
      | sed -r 's/(.*)=/\1_/' \
      | bash
    # | bash -c "${FiltroIndiceAutogen}"
  }
  export -f DescargarDarwinionIndice

 #DescargarDarwinionIndice Instituto_de_Botánica_Darwinion.html
 #tar -zcvf EnlaceIndice.tar.gz html

  function LongitudDarwinionTabla ()
  {
    cat "${1}" \
      | pup "${FiltroTablaI}"
  }
  export -f LongitudDarwinionTabla

  function TransformarDarwinionTabla ()
  {
    cat "${1}" \
      | pup "${FiltroTablaI}" \
      | wc -l \
      | gawk '{for(i=2;i<=$1+1;i++) print "cat '"${1}"' | pup \"table:nth-child(1) > tbody:nth-child(1) > tr:nth-child("i") > td json{}\""}' \
      | bash \
      | bash -c "${FiltroJqIndice}" \
      | bash -c "${FiltroJqAColumnas}" \
      | bash -c "${FiltroOrdenaColumnas}" \
      | sed -r '2,$s/\//'"${EnlacePagina}"'\//' \
      | gawk -F'\t' '{print $1, $2, $3, $4, $5, $6, $7, $8, $9}' OFS='@'
  }
  export -f TransformarDarwinionTabla

  #### Generadores
  declare -gx GeneradorLongitudTabla="
  find html/ -type f -name '*.html' \
    | sort \
    | sed -r 's/(.*)/(echo -n \1: ;  LongitudDarwinionTabla \1 | wc -l)/' \
    | bash
  "
 #bash -c "${GeneradorLongitudTabla}"

  declare -gx GeneradorFormatearTabla="
  find html/ -type f -name '*.html' \
    | sort \
    | sed -r 's/(.*)/  TransformarDarwinionTabla \1 > \1/' \
    | sed -r 's/(.*)html/\1csv/;s/(.*)html/\1csv/' \
    | tail -n 8 \
    | bash
  "
 #bash -c "${GeneradorFormatearTabla}"

  function FormatearDarwinionIndice ()
  {
    cat "${1}" \
      | pup "${FiltroJson01}" \
      | bash -c "${FiltroJqIndice}"
  }
  export -f FormatearDarwinionIndice

#### Verificar elementos css versus registros csv {{{
  declare -gx GeneradorLongitudSalida="
  find csv/ -type f -name '*.csv' \
    | sort \
    | sed -r 's/(.*)/(echo -n \1: ; wc -l < \1)/' \
    | bash \
    | gawk -F':' '{print \$1, \$2-1}' OFS=':'
  "
  ## bash -c "${GeneradorLongitudSalida}"
  #### Verificar
  declare -gx GeneradorVerificacion="
  paste -d'\t' \
     <( bash -c "${GeneradorLongitudTabla}"  ) \
     <( bash -c "${GeneradorLongitudSalida}" )
  "
#### }}}

#### Comprimir csv {{{
# tar -zcvf SalidaIndice.tar.gz csv/
#### }}}

#### Unir archivos csv y exportar a xlsx {{{
# find csv/ -type f -name '*.csv' \
#   | sort \
#   | paste -d' ' -s \
#   | sed -r 's/(.*)/cat \1 > Indice_Especies.csv/' \
#   | bash
# #### Comprobar
# gawk -i inplace -F'@' 'NR==1 {print $0} NR>=1 && !/^codigo/ {print $0}' OFS='@' Indice_Especies.csv
# cat Indice_Especies.csv \
#   | grep -i --color '^codigo'
# wc -l Indice_Especies.csv \
#   | sed -r 's/(.*) (.*)/\2:\1/' \
#   | gawk -F':' '{print $1, $2-1}' OFS=':'
# paste -d'\t' \
#    <( bash -c "${GeneradorLongitudTabla}"  ) \
#    <( bash -c "${GeneradorLongitudSalida}" ) \
#    | gawk -F'[:\t]' '{numcss+=$2;numcsv+=$4} END {print numcss, numcsv}'
#### }}}

#### Corregir enlaces {{{
# gawk -i inplace -F'@' 'NR==1 {print $0} NR>1 {gsub(/amp;/ , "" , $2) ; print $0}' OFS='@' Indice_Especies.csv
#### }}}

#### Exportar csv a xlsx {{{
# source activate py36
# python ExportarCsvAExcel.py Indice_Especies.csv Indice_Especies.xlsx
# source deactivate
#### }}}

#### Cruzar darwinion con base concepcion {{{
 ## Olvide el motivo de este filtro
 #join -t $'\t' -1 1 -2 1 -a 1 -o 0,2.3 \
 #gawk -F '@' 'FNR == NR {keys[$2]=$1; next} {if ($1 in keys) {print $1, $1 in keys} else {print keys[$1], "NA"}}' OFS='@' \
 # awk 'BEGIN{FS=OFS="@";} NR==FNR {a[$1+0]=$2;next;} { $1=$1 OFS ($1+0 in a ? a[$1+0] : "" ); print $0}' \
# let i=1
# csvjoin -c 1,1 --right \
# <( gawk -F'@' 'NR>1 {print $3 }' ../darwinion/Indice_Especies.csv                                                  \
#   | sort | uniq | sed -r 's/ subsp\. .*//;s/ var\. .*//;s/ f\. .*//' | sort | uniq \
#   | sed -r ':a;s/  +/ /g;ta;s/ +$//g' ) \
# <( gawk -F'@' 'NR>1 {print $60}' ../sofi01-correo/BBDD_RM_MNHN_preconsolidada_soloRMsineliminar_scientificName.csv \
#   | sort | uniq | sed -r 's/ subsp\. .*//;s/ var\. .*//;s/ f\. .*//' | sort | uniq \
#   | sed -r ':a;s/  +/ /g;ta;s/ +$//g' ) \
# # | gawk -F',' '{if($1=="") print $0}' OFS='@' \
# # | while IFS= read -r linea ; do echo $i$linea ; let i=i+1 ; done \
# # | gawk -F'[, ]' '{if($3=="") print $0}' \
# # | head -n 1 \
# # | cut -d',' -f 2 \
# # | sed -r 's/(.*)/gawk -F'\''@'\'' '\''{if(\$5==\"\1\") print \$3}'\'' OFS='\''@'\'' Indice_Especies.csv/' \
# # | bash
#  #| sed -r 's/(.*)/cat Indice_Especies.csv | grep -i --color '\''\1'\''/' \
#  #| cut -d' ' -f 1 \
#  #| cut -c1-4 \
#### }}}

#### Paste entre mnhn y darwinion: generar lista extracción {{{
 #paste -d'@' \
 #  <( ../sofi01-correo/BBDD_RM_MNHN_preconsolidada_soloRMsineliminar_scientificName.csv ) \
       csvjoin -c 1,1 --left \
        <( gawk -F'@' 'NR==1 {print $5"-"$6} NR>1 {print $5, $6}' OFS='@' ../sofi01-correo/BBDD_RM_MNHN_preconsolidada_soloRMsineliminar_scientificName.csv \
        | sed -r 's/  +/ /g;s/Oziroe/Oziroë/;s/Oxychloe/Oxychloë/' ) \
        <( gawk -F'@' 'NR==1 {print $5"-"$6} NR>1 {print $5, $6}' OFS='@' ../darwinion/Indice_Especies.csv \
        | sed -r 's/  +/ /g' ) \
        | gawk -F',' '{if($2!="") print}' \
        | sort | uniq -c \
        | gawk -F',' '{print $2}' \
        | sed -r 's/(.*)/gawk -F'\''@'\'' '\''NR>1 \&\& \/\1\/ {print \$5, \$6}'\'' Indice_Especies.csv | sort | uniq -c/' \
        | bash
#### }}}
