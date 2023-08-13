# -*- coding: utf8 -*-
import sys, csv, xlsxwriter
import numpy as np
import pandas as pd
import pandas.io.formats.excel
from PythonFuncionesVarias import ExcelExport

# strinpc01=sys.argv[1]
# strinpc02=sys.argv[2]
# stroutcsv=sys.argv[3]

strinpc01='Listado_Especies_sin_sinonimos.csv'
strinpc02='Darwinion_consulta_01.csv'
stroutcsv='Listado_Especies_sin_sinonimos_frecuencia.csv'

csv_01 = pd.read_csv(strinpc01,sep='@', dtype={'codesp': object})
csv_02 = pd.read_csv(strinpc02,sep='@', dtype={'codigo': object})
csv_01.columns = map(str.lower, csv_01.columns)
csv_02.columns = map(str.lower, csv_02.columns)
csv_01.columns = ['genero_especie', 'codigo', 'primer_titulo', 'tercer_titulo', 'familia_value', 'genero_value', 'especie_value', 'sigla_sp_value', 'subsp_value', 'sigla_ssp_value', 'var_value', 'sigla_var_value', 'forma_value', 'sigla_for_value', 'habito_value', 'status_value', 'elevacion_value']


"""
csv_02["genero-especie"] = csv_02["genero"].map(str) + " " + csv_02["especie"].map(str)
csv_02 = csv_02[['genero-especie', 'codigo', 'enlace', 'titulo', 'descripcion', 'genero', 'especie', 'subespecie', 'variedad', 'forma']]
"""

"""
csv_01_nodup = pd.DataFrame(csv_01.drop_duplicates(subset='genero-especie',keep='first'))
csv_01_nodup['totalwords'] = csv_01_nodup['genero-especie'].str.count(' ') + 1
csv_01_nodup = pd.DataFrame(csv_01_nodup[csv_01_nodup.totalwords > 1])
csv_01_nodup = csv_01_nodup.drop('totalwords', 1)
"""

csv_01['codigo'] = csv_01['codigo'].str.zfill(6)
csv_01['codigo'] = csv_01['codigo'].astype(str)
csv_02['codigo'] = csv_02['codigo'].str.zfill(6)
csv_02['codigo'] = csv_02['codigo'].astype(str)
csv_02_nodup = pd.DataFrame(csv_02[csv_02.codigo != "nan"])
csv_02_nodup['codigo'] = csv_02_nodup['codigo'].astype(str)
csv_mr = pd.merge( csv_01 , csv_02_nodup , on='codigo' , how='left' )
csv_mr.sort_values('genero_especie',inplace=True)

### Exportar csv
csv_mr.to_csv(stroutcsv, sep='@', encoding='utf-8', index=False)

### Exportar xlsx
ExcelExport( stroutcsv )
