import streamlit as st
import pandas as pd
import json
from pymongo import MongoClient
import psycopg2
from sqlalchemy import create_engine, text

CONFIG_PATH = "config/config.json"

with open(CONFIG_PATH) as config_fp:
    config_json = json.load(config_fp)

st.write(config_json)

if 'postgres_url' in config_json:
    postgres_url = config_json['postgres_url']
    engine = create_engine(postgres_url)

    df = pd.read_sql_query('select * from demo_table',con=engine)

    st.write("Contents of 'demo_table' table:")

    st.data_editor(df)

if 'mongodb_url' in config_json:
    mongodb_url = config_json['mongodb_url']
    client = MongoClient(mongodb_url)

    db = client['demo_db']
    collection = db['demo_collection']

    cursor = collection.find({})
    for document in cursor:
          print(document)
