#### Variables {{{
  strxls="Darwinion_no_encontradas.xlsx"
  strdar="Darwinion_no_encontradas.csv"
  strind="Indice_Especies.csv"
  strlis="Enlaces_descarga_2019_01_03.txt"
  strlisget=$( basename "${strlis}" .txt).sh
 #echo src/${strlisget}
  strlab="Listado_Especies_sin_sinonimos_label.csv"
  strsin="Listado_Especies_sin_sinonimos.csv"
  strb01="Darwinion_consulta_01.csv"
#### }}}

#### Corregir archivo y cruzar con csvjoin {{{
# xlsx2csv -d'@' ${strxls} > ${strdar}
# #### Corregir
# sed -r -i 's/ x / /;s/ \?//;s/ sp\.//;s/ +@/@/g' ${strdar}
# : '
# #### Cruzar con pandas merge
# #### strinpc01=${strdar}
# #### strinpc02=${strind}
# #### stroutcsv=${strb01}
# '
# source activate py36
# python MergeBuscarv.py
# source deactivate
#### }}}

#### Guardar enlaces para descarga Indice Darwinion {{{
# : '
# #    Exportar id con formato y enlace Lista genero-especie desde 7364 valores
# #    unicos y corregidos. Luego genera lista de descarga cruzando con
# #    Indice_Especies.csv Puede generar mas de 1 combinacion de genero-especie
# #    al cruzar con Indice_Especies porque existe mas de 1 genero-especie en
# #    darwinion sin ser duplicado.  Se han excluido generos sin especie desde
# #    7364 dejandolos para revision antes de extraer de darwinion.
# #    Se puede tomar el tiempo de este codigo con el comando time.
# '
# gawk -F'@' 'NR>1 && !/000NA/ {print $1}' ${strb01} \
#   | gawk -F' ' '{if(NF==2) {print "gawk -F'\''@'\'' '\''NR>1 && $5~/^"$1"$/ && $6~/^"$2"$/ {printf \"%06d %s\\n\",$1,$2}'\'' '"${strind}"'"}}' \
#   | bash \
#   > src/${strlis}
# #### Se retiro opcion para genero sin especie para revision 
# ##| gawk -F' ' '{if(NF==1) {print "gawk -F'\''@'\'' '\''NR>1 && $5~/^"$1"$/ {printf \"%06d %s\\n\",$1,$2}'\'' '"${strind}"'"}}'
#### }}}

#### Verificacion de lista de descarga darwinion {{{
# : '
# #    Hay enlaces con espacios en blanco lo que dificulta
# #    la generacion del script de descarga. Se corrige.
# '
# #### Corregir columnas
# gawk -F' ' '{if(NF>2) print NR, FILENAME}' src/${strlis} \
#   | sed -r 's/(.*) (.*)/sed -r -i '\''\1s\/(.*) (.*)\/\\1\\2\/'\'' \2/' \
#   | bash
# #### Comprobar columnas
# gawk -F' ' '{print NF}' src/${strlis} | sort | uniq -c
# #### Comprobar duplicados
# declare -gx FiltroDuplicados0001="
# cat src/${strlis} | sort | uniq -c \
#   | sed -r 's/^ +//g' \
#   | gawk -F' ' '{if(\$1>1) print \$0}' \
#   | wc -l \
#   | sed -r 's/ //g'
# "
# #### Agregar 1 duplicado a proposito
# #### sed -r -i '$p'       src/${strlis}
# if [[ $(bash -c "${FiltroDuplicados0001}") == "" ]] ; then
#   echo No existen duplicados en fichero src/${strlis}
# else
#   echo Existen $(bash -c "${FiltroDuplicados0001}") duplicados en fichero src/${strlis}
# fi
#### }}}

#### Generar enlaces descarga {{{
# #### Generamos codigo y guardamos en archivo script
# gawk -F' ' '{print "  wget -c \""$2"\" -O html/"$1".html"}' src/${strlis} \
#   > src/${strlisget}
# #### Verificamos numero de enlaces
# wc -l src/${strlis}
# wc -l src/${strlisget}
#### }}}

#### Comprimir funciones descarga especies {{{
# tar -zcvf Comprimido_Funcion_Descarga_Especies.tar.gz \
#   DescargarEspecie.sh \
#   src/${strlis} \
#   src/${strlisget}
#### }}}

#### Realizar descarga {{{
# cat src/${strlisget} \
#   | head -n 10 \
#   | parallel -j 10
#### }}}

#### Comprimir descargas {{{
# tar -zcvf Comprimido_Enlaces_Especies.tar.gz html/
#### }}}

#### Selectores css individuales {{{
  declare -gx strcsstab02val0001="table:nth-child(2) > tbody              > tr:nth-child(1) > td > font text{}"
  declare -gx strcsstab02val0002="table:nth-child(2) > tbody              > tr:nth-child(3) > td > font text{}"
  declare -gx strcsstab04lab0001="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(1)  > > td:nth-child(1) text{}"
  declare -gx strcsstab04lab0002="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(2)  > > td:nth-child(1) text{}"
  declare -gx strcsstab04lab0003="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(3)  > > td:nth-child(1) text{}"
  declare -gx strcsstab04lab0004="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(4)  > > td:nth-child(1) text{}"
  declare -gx strcsstab04lab0005="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(5)  > > td:nth-child(1) text{}"
  declare -gx strcsstab04lab0006="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(6)  > > td:nth-child(1) text{}"
  declare -gx strcsstab04lab0007="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(7)  > > td:nth-child(1) text{}"
  declare -gx strcsstab04lab0008="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(8)  > > td:nth-child(1) text{}"
  declare -gx strcsstab04lab0009="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(9)  > > td:nth-child(1) text{}"
  declare -gx strcsstab04lab0010="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(10) > > td:nth-child(1) text{}"
  declare -gx strcsstab04lab0011="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(11) > > td:nth-child(1) text{}"
  declare -gx strcsstab04lab0012="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(12) > > td:nth-child(1) text{}"
  declare -gx strcsstab04lab0013="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(13) > > td:nth-child(1) text{}"
  declare -gx strcsstab04lab0014="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(14) > > td:nth-child(1) text{}"
  declare -gx strcsstab04lab0015="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(15) > > td:nth-child(1) text{}"
  declare -gx strcsstab04lab0016="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(16) > > td:nth-child(1) text{}"
  declare -gx strcsstab04lab0017="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(17) > > td:nth-child(1) text{}"
 #declare -gx strcsstab04lab0018="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(18) > > td:nth-child(1) text{}"
 #declare -gx strcsstab04lab0019="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(19) > > td:nth-child(1) text{}"
 #declare -gx strcsstab04lab0020="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(20) > > td:nth-child(1) text{}"
 #declare -gx strcsstab04lab0021="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(21) > > td:nth-child(1) text{}"
 #declare -gx strcsstab04lab0022="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(22) > > td:nth-child(1) text{}"
  declare -gx strcsstab04lab0023="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(23) > > td:nth-child(1) text{}"
  declare -gx strcsstab04lab0024="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(24) > > td:nth-child(1) text{}"
  declare -gx strcsstab04val0001="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(1)  > > td:nth-child(2) text{}"
  declare -gx strcsstab04val0002="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(2)  > > td:nth-child(2) text{}"
  declare -gx strcsstab04val0003="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(3)  > > td:nth-child(2) text{}"
  declare -gx strcsstab04val0004="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(4)  > > td:nth-child(2) text{}"
  declare -gx strcsstab04val0005="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(5)  > > td:nth-child(2) text{}"
  declare -gx strcsstab04val0006="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(6)  > > td:nth-child(2) text{}"
  declare -gx strcsstab04val0007="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(7)  > > td:nth-child(2) text{}"
  declare -gx strcsstab04val0008="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(8)  > > td:nth-child(2) text{}"
  declare -gx strcsstab04val0009="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(9)  > > td:nth-child(2) text{}"
  declare -gx strcsstab04val0010="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(10) > > td:nth-child(2) text{}"
  declare -gx strcsstab04val0011="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(11) > > td:nth-child(2) text{}"
  declare -gx strcsstab04val0012="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(12) > > td:nth-child(2) text{}"
  declare -gx strcsstab04val0013="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(13) > > td:nth-child(2) text{}"
  declare -gx strcsstab04val0014="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(14) > > td:nth-child(2) text{}"
  declare -gx strcsstab04val0015="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(15) > > td:nth-child(2) text{}"
  declare -gx strcsstab04val0016="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(16) > > td:nth-child(2) text{}"
  declare -gx strcsstab04val0017="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(17) > > td:nth-child(2) text{}"
 #declare -gx strcsstab04val0018="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(18) > > td:nth-child(2) text{}"
 #declare -gx strcsstab04val0019="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(19) > > td:nth-child(2) text{}"
 #declare -gx strcsstab04val0020="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(20) > > td:nth-child(2) text{}"
 #declare -gx strcsstab04val0021="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(21) > > td:nth-child(2) text{}"
 #declare -gx strcsstab04val0022="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(22) > > td:nth-child(2) text{}"
 #declare -gx strcsstab04val0023="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(23) > > td:nth-child(2) text{}"
 #declare -gx strcsstab04val0024="table:nth-child(4) > tbody:nth-child(1) > tr:nth-child(24) > > td:nth-child(2) text{}"
#### }}}

#### Selectores css grupales {{{
  declare -gx grpcsstab00val0000="table json{}"
#### }}}

#### Filtros jq {{{
  declare -gx strjq0001="
  jq 'if ( .[2].children[0].children[22].children[0].children[0].text == \"Sinónimos:\" ) then (
          . | {
          primer_titulo   : .[1].children[0].children[0].children[0].children[0].text ,
          tercer_titulo   : .[1].children[0].children[2].children[0].children[0].text ,
          familia_label   : .[2].children[0].children[0].children[0].text ,
          familia_value   : .[2].children[0].children[0].children[1].text ,
          genero_label    : .[2].children[0].children[1].children[0].text ,
          genero_value    : .[2].children[0].children[1].children[1].text ,
          especie_label   : .[2].children[0].children[2].children[0].text ,
          especie_value   : .[2].children[0].children[2].children[1].text ,
          sigla_sp_label  : .[2].children[0].children[3].children[0].text ,
          sigla_sp_value  : .[2].children[0].children[3].children[1].text ,
          subsp_label     : .[2].children[0].children[4].children[0].text ,
          subsp_value     : .[2].children[0].children[4].children[1].text ,
          sigla_ssp_label : .[2].children[0].children[5].children[0].text ,
          sigla_ssp_value : .[2].children[0].children[5].children[1].text ,
          var_label       : .[2].children[0].children[6].children[0].text ,
          var_value       : .[2].children[0].children[6].children[1].text ,
          sigla_var_label : .[2].children[0].children[7].children[0].text ,
          sigla_var_value : .[2].children[0].children[7].children[1].text ,
          forma_label     : .[2].children[0].children[8].children[0].text ,
          forma_value     : .[2].children[0].children[8].children[1].text ,
          sigla_for_label : .[2].children[0].children[9].children[0].text ,
          sigla_for_value : .[2].children[0].children[9].children[1].text ,
          habito_label    : .[2].children[0].children[14].children[0].text ,
          habito_value    : .[2].children[0].children[14].children[1].text ,
          status_label    : .[2].children[0].children[15].children[0].text ,
          status_value    : .[2].children[0].children[15].children[1].text ,
          elevacion_label : .[2].children[0].children[16].children[0].text ,
          elevacion_value : .[2].children[0].children[16].children[1].text ,
          sinonimos_label : .[2].children[0].children[22].children[0].children[0].text ,
          sinonimos_count : .[2].children[0].children[22].children[0].children[1:] | length ,
          sinonimos_value : .[2].children[0].children[22].children[0].children[1:]
          }
          )
        else (
          . | {
          primer_titulo   : .[1].children[0].children[0].children[0].children[0].text ,
          tercer_titulo   : .[1].children[0].children[2].children[0].children[0].text ,
          familia_label   : .[2].children[0].children[0].children[0].text ,
          familia_value   : .[2].children[0].children[0].children[1].text ,
          genero_label    : .[2].children[0].children[1].children[0].text ,
          genero_value    : .[2].children[0].children[1].children[1].text ,
          especie_label   : .[2].children[0].children[2].children[0].text ,
          especie_value   : .[2].children[0].children[2].children[1].text ,
          sigla_sp_label  : .[2].children[0].children[3].children[0].text ,
          sigla_sp_value  : .[2].children[0].children[3].children[1].text ,
          subsp_label     : .[2].children[0].children[4].children[0].text ,
          subsp_value     : .[2].children[0].children[4].children[1].text ,
          sigla_ssp_label : .[2].children[0].children[5].children[0].text ,
          sigla_ssp_value : .[2].children[0].children[5].children[1].text ,
          var_label       : .[2].children[0].children[6].children[0].text ,
          var_value       : .[2].children[0].children[6].children[1].text ,
          sigla_var_label : .[2].children[0].children[7].children[0].text ,
          sigla_var_value : .[2].children[0].children[7].children[1].text ,
          forma_label     : .[2].children[0].children[8].children[0].text ,
          forma_value     : .[2].children[0].children[8].children[1].text ,
          sigla_for_label : .[2].children[0].children[9].children[0].text ,
          sigla_for_value : .[2].children[0].children[9].children[1].text ,
          habito_label    : .[2].children[0].children[14].children[0].text ,
          habito_value    : .[2].children[0].children[14].children[1].text ,
          status_label    : .[2].children[0].children[15].children[0].text ,
          status_value    : .[2].children[0].children[15].children[1].text ,
          elevacion_label : .[2].children[0].children[16].children[0].text ,
          elevacion_value : .[2].children[0].children[16].children[1].text ,
          sinonimos_label : .[2].children[0].children[24].children[0].children[0].text ,
          sinonimos_count : .[2].children[0].children[24].children[0].children[1:] | length ,
          sinonimos_value : .[2].children[0].children[24].children[0].children[1:]
          }
          )
          end'
  "
  declare -gx strjq0002="
    jq '. | {
          sinonimos_value : .[2].children[0].children[22].children[0].children[]
        }' \
    | jq -s 'length'
  "
  declare -gx strjq0003="
  jq 'if ( .[2].children[0].children[22].children[0].children[0].text == \"Sinónimos:\" ) then
        (
        . | {
          sinonimos_label : .[2].children[0].children[22].children[0].children[0].text
        }
        )
        else
        (
        . | {
          sinonimos_label : .[2].children[0].children[24].children[0].children[0].text
        }
        )
        end'
  "
  declare -gx strjq0004="
  jq 'if ( .[2].children[0].children[22].children[0].children[0].text == \"Sinónimos:\" ) then
        (
        . | {
          sinonimos_label : .[2].children[0].children[22].children[0].children[0].text
        }
        )
        else
        (
        . | {
          sinonimos_label : .[2].children[0].children[24].children[0].children[0].text
        }
        )
        end' \
    | jq -s 'length'
  "
  declare -gx strjq0005="
    jq 'paths'
  "
  declare -gx strjq0006="
    jq -c '. |
        .[].children[0].children[].children[0].children[]? |
        paths |
        select( .text == \"Sinónimos:\" )
        '
  "
  declare -gx strjq0007="
  jq '[paths as \$path | select(getpath(\$path) == \"Sinónimos:\") | \$path]'
  "
  declare -gx strjq0008="
  jq -f wrangle.jq
  "
  declare -gx strjq0009="
  jq '
          . | {
          col_00_codesp          : input_filename | split(\"/\")[-1] | split(\".\")[0]     ,
          col_01_primer_titulo   : .[1].children[0].children[0].children[0].children[0].text ,
          col_02_tercer_titulo   : .[1].children[0].children[2].children[0].children[0].text ,
          col_03_familia_label   : .[2].children[0].children[0].children[0].text ,
          col_04_familia_value   : .[2].children[0].children[0].children[1].text ,
          col_05_genero_label    : .[2].children[0].children[1].children[0].text ,
          col_06_genero_value    : .[2].children[0].children[1].children[1].text ,
          col_07_especie_label   : .[2].children[0].children[2].children[0].text ,
          col_08_especie_value   : .[2].children[0].children[2].children[1].text ,
          col_09_sigla_sp_label  : .[2].children[0].children[3].children[0].text ,
          col_10_sigla_sp_value  : .[2].children[0].children[3].children[1].text ,
          col_11_subsp_label     : .[2].children[0].children[4].children[0].text ,
          col_12_subsp_value     : .[2].children[0].children[4].children[1].text ,
          col_13_sigla_ssp_label : .[2].children[0].children[5].children[0].text ,
          col_14_sigla_ssp_value : .[2].children[0].children[5].children[1].text ,
          col_15_var_label       : .[2].children[0].children[6].children[0].text ,
          col_16_var_value       : .[2].children[0].children[6].children[1].text ,
          col_17_sigla_var_label : .[2].children[0].children[7].children[0].text ,
          col_18_sigla_var_value : .[2].children[0].children[7].children[1].text ,
          col_19_forma_label     : .[2].children[0].children[8].children[0].text ,
          col_20_forma_value     : .[2].children[0].children[8].children[1].text ,
          col_21_sigla_for_label : .[2].children[0].children[9].children[0].text ,
          col_22_sigla_for_value : .[2].children[0].children[9].children[1].text ,
          col_23_habito_label    : .[2].children[0].children[14].children[0].text ,
          col_24_habito_value    : .[2].children[0].children[14].children[1].text ,
          col_25_status_label    : .[2].children[0].children[15].children[0].text ,
          col_26_status_value    : .[2].children[0].children[15].children[1].text ,
          col_27_elevacion_label : .[2].children[0].children[16].children[0].text ,
          col_28_elevacion_value : .[2].children[0].children[16].children[1].text
          }' \
  "
  #### Convertir json a tsv
  declare -gx strjq0010="
        jq -s -r '(map(keys) | add | unique) as \$cols | map(. as \$row | \$cols | map(\$row[.])) as \$rows | \$cols, \$rows[] | @tsv'
  "
#### }}}

#### Preparar extraccion 02 parte 01 sin sinonimos obsoleto {{{
# : '
# #    Este filtro tiene que ser reemplazado para usar el argumento del archivo
# #    de entrada como valor de codigo a asignar en el archivo de salida
# '
# declare -gx FiltroCat="
# find html/ -type f \
#   | sort \
#   | sed -r 's/(.*)/cat \1/'
# "
# declare -gx FiltroSel0001="
#     sed -r 's/(.*)/pup '"${strcsstab020001}"'/'
# "
#### }}}

#### Ejecutar extraccion 02 parte 01 sin sinonimos {{{
# bash -c "${FiltroCat}" \
#   | sed -r 's/(.*)/\1 | pup '\'''"${grpcsstab00val0000}"''\''/' \
#   | bash \
#   | bash -c "${strjq0009}" \
#   > ${strlab}
# wc -l ${strlab}
#### }}}

#### Convertir html a json {{{
# #### Convertir html a json
# find html/ -type f \
#   | sort \
#   | sed -r 's/(.*)\/(.*)\.(.*)/cat \1\/\2\.\3 | pup '\''table json{}'\'' > json\/\2\.json/' \
#   | bash
#### }}}

#### Funcion preparar extraccion 02 parte 01 definitiva {{{
# #### Definir funcion
# function ExtraccionEspecies () {
#   echo    "${strjq0009}" "${1}" \
#     | bash \
#     | bash -c "${strjq0010}"
# }
# export -f ExtraccionEspecies
# #### Generar codigo call
# find json/ -type f \
#   | sort \
#   | sed -r 's/(.*)/ExtraccionEspecies \1/' \
#   | bash \
#   > ${strlab}
# #### Quitar encabezados repetidos
# gawk -i inplace -F'\t' 'NR==1 {print $0} NR>1 && !/col_[0-9]{2}_/ {print $0}' OFS='\t' ${strlab}
# wc -l ${strlab}
#### }}}

#### Limpiar archivo sin sinonimos {{{
# #### Corregir nombres columnas
# sed -r -i '1s/col_[0-9]{2}_//g' ${strlab}
# #### Cambiar separador
# sed -r -i 's/\t/@/g' ${strlab}
# #### Agregar columna 1 con genero-especie para cruce
# gawk -i inplace -F'@' 'NR==1 {print "genero_especie", $0} NR>1 {print $7" "$9, $0}' OFS='@' ${strlab}
# #### Verificar label columnas identicas
# ListarCabecerasArroba ${strlab} \
#   | grep -i --color 'label:' \
#   | sed -r 's/(.*):(.*):(.*)/gawk -F'\''@'\'' '\''NR>1 {print \$\3}'\'' OFS='\''@'\'' \1 | sort | uniq -c/' \
#   | bash
# wc -l ${strlab}
# gawk -F'@' '{print NF}' ${strlab} | sort | uniq -c
#### }}}

#### Verificacion de otras columnas {{{
# #### Dimensiones
# wc -l ${strlab}
# gawk -F'@' '{print NF}' ${strlab} | sort | uniq -c
# #### Quitar ampersand extra html
# sed -r -i 's/amp;//g' ${strlab}
# #### Quitar dobles espacios
# sed -r -i ':a;s/  +/ /g;ta' ${strlab}
# #### Corregir apostrofe html
# sed -r -i "s/\&#39;/\'/g" ${strlab}
# #### Verificamos otras columnas
# gawk -F'@' 'NR>1 {print $0}' ${strlab} \
#   | grep -i -o --color 'amp;\|[A-z]&#[0-9]\{2\};\|  \| $' \
#   | sort | uniq -c \
#   | sed -r    "s/\&#39;/\'/"
# #### Quitar columnas label
# ListarCabecerasArroba ${strlab} \
#   | grep -i -v --color 'label:' \
#   | cut -d':' -f 3 \
#   | sed -r 's/(.*)/\$\1/' \
#   | paste -d',' -s \
#   | sed -r 's/(.*)/gawk -F'\''@'\'' '\''{print \1}'\'' OFS='\''@'\'' '"${strlab}"' > '"${strsin}"'/' \
#   | bash
# #### Dimensiones
# wc -l ${strsin}
# gawk -F'@' '{print NF}' ${strsin} | sort | uniq -c
#### }}}

#### Exportar csv a xlsx {{{
# source activate py36
# python ExportarCsvAExcel.py Listado_Especies_sin_sinonimos.csv Listado_Especies_sin_sinonimos.xlsx 17
# source deactivate
#### }}}

#### Comprimir reporte {{{
 #tar -zcvf ../sofi01-correo/BBDD_RM_MNHN_preconsolidada_soloRMsineliminar_output_resultado_latin1.tar.gz \
 #  ../sofi01-correo/BBDD_RM_MNHN_preconsolidada_soloRMsineliminar_output_resultado_latin1.xlsx
# 7za a -t7z -aoa -mx=9 ../sofi01-correo/BBDD_RM_MNHN_preconsolidada_soloRMsineliminar_output_resultado_latin1.7z \
#   ../sofi01-correo/BBDD_RM_MNHN_preconsolidada_soloRMsineliminar_output_resultado_latin1.xlsx
# tar -zcvf Extraccion_02_parte_01.tar.gz \
#   Listado_Especies_sin_sinonimos_frecuencia.xlsx \
#   ../sofi01-correo/BBDD_RM_MNHN_preconsolidada_soloRMsineliminar_output_resultado_latin1.7z
#### }}}
