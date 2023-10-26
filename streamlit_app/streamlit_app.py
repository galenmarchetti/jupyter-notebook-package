import streamlit as st
import pandas as pd
import json
from pymongo import MongoClient
import psycopg2
from sqlalchemy import create_engine, text

CONFIG_PATH = "config/config.json"

with open(CONFIG_PATH) as config_fp:
    config_file = json.load(config_fp)

st.write(config_file)

postgres_url = config_file['postgres_url']
engine = create_engine(postgres_url)

df = pd.read_sql_query('select * from demo_table',con=engine)

st.write("Contents of 'demo_table' table:")

st.data_editor(df)
