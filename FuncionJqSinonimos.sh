#### Variables {{{
  declare -gx strlin="Listado_Sinonimos.csv"
  declare -gx strxin="Listado_Sinonimos.xlsx"
  declare -gx strdet="Listado_Sinonimos_Detalle.csv"
  declare -gx strxet="Listado_Sinonimos_Detalle.xlsx"
#### }}}

#### Extraer json a json sin {{{
# find json/ -type f -name '*[0-9]\.json' \
#   | sort \
#   | sed -r 's/(.*)/jq -f wrangle.jq --compact-output --raw-output \1/' \
#   | bash \
#   | gawk -F'[:,]' '{if(NF>4) {print $1":"$2","$3":"$4"]"} else {print $1":"$2","$3":"$4}}' \
#   | gawk -F'[:,]' '{if($4==null) {print "jq '\''[{ archivo : "$2" , sinonimos :  "$4"'\'' "$2" > "$2}
#                     else         {print "jq '\''[{ archivo : "$2" , sinonimos : ."$4"'\'' "$2" > "$2}}' \
#   | sed -r 's/"//g;s/json\//\"/;s/\.json/\"/;s/\.null/null/;s/\[0\]\.text/\[1:\]/;s/(.*)\.json/\1_sin\.json/' \
#   | bash \
# # | grep -A2 '069817' \
# # | grep -iA5 '073691' \
#### }}}

#### Contar sinonimos por archivo sin {{{
# #### Funcion
# function ContarSinonimos () {
#   grep -H -c 'href' "${1}"
# }
# export -f ContarSinonimos
# #### Generar call
# declare -gx FiltroContarSinon="
# find json/ -type f -name '*sin*' \
#   | sort \
#   | sed -r 's/(.*)/ContarSinonimos \1/' \
#   | bash
# "
# # | grep '071485' \
# function ExtraerSinonimos () {
#   ContarSinonimos "${1}" \
#     | sed -r 's/(.*):(.*)/ExtraerSinonimos:\1:\2/' \
#     | gawk -F':' '{if($3!=0) {for(i=0;i<$3;i++) print "jq '\''{ col_00_archivo  : .[0].archivo , col_01_sinonimo : .[0].sinonimos["i"].text , col_02_enlace_sinonimo : .[0].sinonimos["i"].href }'\'' "$2}
#                    else      {                  print "jq '\''{ col_00_archivo  : .[0].archivo , col_01_sinonimo : null                     , col_02_enlace_sinonimo : null                     }'\'' "$2}}' \
#     | bash \
#     | jq -s -r '(map(keys) | add | unique) as $cols | map(. as $row | $cols | map($row[.])) as $rows | $cols, $rows[] | @tsv' \
#     | sed -r '1s/col_[0-9]{2}_//g' \
#     | sed -r 's/\t/@/g
#               s/\&amp;/\&/g
#               s/  +/ /g
#               s/ +@/@/g
#               s/@ +/@/g
#               s/ +$//g' \
#     | sed -r "s/\&#39;/\'/g"
# }
# export -f ExtraerSinonimos
 #bash -c "${FiltroContarSinon}"
# #### Generar call
# function LlamarExtraerSinonimos () {
# find json/ -type f -name '*sin*' \
#   | sort \
#   | sed -r 's/(.*)/ExtraerSinonimos \1/' \
#   | bash \
#   | gawk -F'@' 'NR==1 {print $0} NR>1 && !/^archivo/ {print $0}' OFS='@' \
#   > ${strlin}
# }
# export -f LlamarExtraerSinonimos
# time LlamarExtraerSinonimos
 #  | grep '196493\|073692' \
 #ExtraerSinonimos json/071485_sin.json
 #ExtraerSinonimos json/069817_sin.json
 #ExtraerSinonimos json/196493_sin.json
 #ExtraerSinonimos json/073692_sin.json
#  #| cut -d':' -f 1 \
#  #| sort | uniq -c \
#  #| wc -l
#### }}}

#### Expandir columnas {{{
  : '
  #    Revisar posteriormente archivo inconsistente 069817
  '
  gawk -F'@' '{print $1,$3}' OFS='@' ${strlin} > ${strdet}
  gawk -i inplace -F'[@?&]'  'NR==1 {print "codigo@enlace_sinonimo@forma@variedad@subespecie@espcod@especie@genero@singenerode@sinespeciede@sincod" } NR>1 {if($2!="" && $2!~/novedades/ && $6!~/span class/) {print $1,$2"&"$3"&"$4"&"$5"&"$6"&"$7"&"$8"&"$9"&"$10"&"$11,$3,$4,$5,$6,$7,$8,$9,$10,$11} else {print $1,$2"&"$3"&"$4"&"$5"&"$6"&"$7"&"$8"&"$9"&"$10"&"$11"@@@@@@@@@"}}' OFS='@' ${strdet}
  #### Limpiar columnas expandidas
  gawk -i inplace -F'@' 'NR==1 {print $0} NR>1 { sub(/forma=/,"",$3); sub(/variedad=/,"",$4); sub(/subespecie=/,"",$5); sub(/EspCod=/,"",$6); sub(/especie=/,"",$7); sub(/genero=/,"",$8); sub(/SinGeneroDe=/,"",$9); sub(/SinEspecieDe=/,"",$10); sub(/sincod=/,"",$11); print $0}' OFS='@' ${strdet}
  #### Agregar enlace
  gawk -i inplace -F'@' 'NR==1 {print $0} NR>1 { sub(/^/,"http://www2.darwin.edu.ar",$2) ; print $0}' OFS='@' ${strdet}
 #gawk -F'[@]' 'NR>1  {if($2!="" && $2!~/novedades/ && $2!~/span class/) print $2}' ${strdet} \
 #  | gawk -F'[&]' '{print NF}' \
 #  | sort | uniq -c
 #gawk -F'[@?&]' 'NR==1 {print "codigo@titulo_sinonimo@enlace_sinonimo@forma@variedad@subespecie@espcod@especie@genero@singenerode@sinespeciede@sincod" }
 #                NR>1 {if($3!="" && $3!~/novedades/ && $7!~/span class/)
 #                print $1,$2,$3"?"NR, FILENAME}' ${strlin} \
  # | gawk -F'&' '{if(NF==9) print NR, $0}' \
  # | sort | uniq -c
#### }}}

#### Merge para unir titulo de nuevo {{{
# source activate py36
# python MergeSinonimo.py
# source deactivate
#### }}}

#### Exportar csv a xlsx {{{
# source activate py36
# python ExportarCsvAExcel.py ${strdet} ${strxet} 3
# source deactivate
#### }}}
