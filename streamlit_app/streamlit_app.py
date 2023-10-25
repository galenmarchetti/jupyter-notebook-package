import streamlit as st
import pandas as pd
import json
from sqlalchemy import create_engine

CONFIG_PATH = "config/config.json"

with open(CONFIG_PATH) as config_fp:
    config_file = json.load(config_fp)

postgres_url = config_file['postgres_url']

#engine = create_engine('postgresql://username:password@localhost:5432/mydatabase')

#df = pd.read_sql_query('select * from "my_table"',con=engine)

st.write("Postgres URL: " + postgres_url)

st.write("Hello World!")
