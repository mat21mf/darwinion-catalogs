# -*- coding: utf8 -*-
import sys, csv, xlsxwriter
import numpy as np
import pandas as pd
import pandas.io.formats.excel
from PythonFuncionesVarias import ExcelExport

# strinpc01=sys.argv[1]
# strinpc02=sys.argv[2]
# stroutcsv=sys.argv[3]

strinpc01='Listado_Sinonimos.csv'
strinpc02='Listado_Sinonimos_Detalle.csv'
stroutcsv='Listado_Sinonimos_Detalle.csv'

csv_01 = pd.read_csv(strinpc01,sep='@', dtype={'archivo': object})
csv_02 = pd.read_csv(strinpc02,sep='@', dtype={'codigo': object,'espcod': object,'sincod': object})
csv_01.columns = map(str.lower, csv_01.columns)
csv_02.columns = map(str.lower, csv_02.columns)
csv_01.columns = ['codigo', 'titulo_sinonimo', 'enlace_sinonimo']


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
"""
csv_02_nodup = pd.DataFrame(csv_02[csv_02.codigo != "nan"])
csv_02_nodup['codigo'] = csv_02_nodup['codigo'].astype(str)
"""
csv_mr = pd.merge( csv_01 , csv_02 , left_index=True, right_index=True , how='outer' )
csv_mr.sort_values('titulo_sinonimo',inplace=True)
csv_mr = csv_mr.drop('codigo_y', 1)
csv_mr = csv_mr.drop('enlace_sinonimo_x', 1)
csv_mr.columns = ['codigo', 'titulo_sinonimo', 'enlace_sinonimo', 'forma', 'variedad', 'subespecie', 'espcod', 'especie', 'genero', 'singenerode', 'sinespeciede', 'sincod']

### Exportar csv
csv_mr.to_csv(stroutcsv, sep='@', encoding='utf-8', index=False)

### Exportar xlsx
ExcelExport( stroutcsv )
