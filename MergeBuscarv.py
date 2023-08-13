# -*- coding: utf8 -*-
import sys, csv, xlsxwriter
import numpy as np
import pandas as pd
import pandas.io.formats.excel
from PythonFuncionesVarias import ExcelExport

# strinpc01=sys.argv[1]
# strinpc02=sys.argv[2]
# stroutcsv=sys.argv[3]

strinpc01='Darwinion_no_encontradas.csv'
strinpc02='Indice_Especies.csv'
stroutcsv='Darwinion_consulta_01.csv'

csv_01 = pd.read_csv(strinpc01,sep='@')
csv_02 = pd.read_csv(strinpc02,sep='@', dtype={'codigo': object})
csv_01.columns = map(str.lower, csv_01.columns)
csv_01.columns = ['genero-especie', 'cruce-buscarv']

csv_02["genero-especie"] = csv_02["genero"].map(str) + " " + csv_02["especie"].map(str)
csv_02 = csv_02[['genero-especie', 'codigo', 'enlace', 'titulo', 'descripcion', 'genero', 'especie', 'subespecie', 'variedad', 'forma']]

csv_01_nodup = pd.DataFrame(csv_01.drop_duplicates(subset='genero-especie',keep='first'))
csv_01_nodup['totalwords'] = csv_01_nodup['genero-especie'].str.count(' ') + 1
csv_01_nodup = pd.DataFrame(csv_01_nodup[csv_01_nodup.totalwords > 1])
csv_01_nodup = csv_01_nodup.drop('totalwords', 1)
csv_02_nodup = pd.DataFrame(csv_02.drop_duplicates(subset='genero-especie',keep='first'))

csv_01_nodup['genero-especie'] = csv_01_nodup['genero-especie'].astype(str)
csv_02_nodup['genero-especie'] = csv_02_nodup['genero-especie'].astype(str)
csv_mr = pd.merge( csv_01_nodup , csv_02_nodup , on='genero-especie' , how='left' )
csv_mr.sort_values('genero-especie',inplace=True)

### Exportar csv
csv_mr.to_csv(stroutcsv, sep='@', encoding='utf-8', index=False)

### Exportar xlsx
ExcelExport( stroutcsv )
