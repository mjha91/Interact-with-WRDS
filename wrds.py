# import
import pandas as pd

# connect to wrds
import wrds
db = wrds.Connection()

# find the library
print(db.list_libraries()) # available libraries
print(db.list_tables(library="crspq")) # datasets within a given library
print(db.describe_table(library="crspq", table="holdings")) #the table

# sample data
data_sample = db.get_table(library="crspq", table="holdings", columns=['report_dt', 'crsp_portno', 'cusip', 'market_val', 'maturity_dt', 'permco', 'permno', 'ticker', 'security_name'], obs=10)
print(data_sample)

# data we need
data = db.raw_sql("select report_dt, crsp_portno, cusip, market_val, permco, permno, ticker, security_name, maturity_dt \
                  from crspq.holdings where report_dt between '2010-01-01' and '2010-12-31'")
data['report_dt'] = pd.to_datetime(data['report_dt'], errors='coerce') #date needs to be taken care of
data['maturity_dt'] = pd.to_datetime(data['maturity_dt'], errors='coerce')
data.to_stata('2010crsp_holdings.dta', convert_dates={'report_dt': 'td', 'maturity_dt': 'td'}) 