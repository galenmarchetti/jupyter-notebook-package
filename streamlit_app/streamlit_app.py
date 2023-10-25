import streamlit as st
import pandas as pd
import json
import psycopg2
from sqlalchemy import create_engine, text

CONFIG_PATH = "config/config.json"

with open(CONFIG_PATH) as config_fp:
    config_file = json.load(config_fp)

postgres_url = config_file['postgres_url']

engine = create_engine(postgres_url)

with engine.connect() as con:
    query = "SELECT datname FROM pg_database WHERE datistemplate = false;"
    rs = con.execute(text(query))

    for row in rs:
        st.write(row)

#df = pd.read_sql_query('select * from "my_table"',con=engine)

st.write("Hello World!")
