import streamlit as st
import pandas as pd
import json
from pymongo import MongoClient
import psycopg2
from sqlalchemy import create_engine, text

CONFIG_PATH = "config/config.json"
MONGODB_CONFIG_KEY = 'mongodb_url'
POSTGRES_CONFIG_KEY = 'postgres_url'

with open(CONFIG_PATH) as config_fp:
    config_json = json.load(config_fp)

if POSTGRES_CONFIG_KEY in config_json and config_json[POSTGRES_CONFIG_KEY] != "":
    postgres_url = config_json[POSTGRES_CONFIG_KEY]
    engine = create_engine(postgres_url)

    df = pd.read_sql_query('select * from demo_table',con=engine)

    st.write("**Contents of 'demo_table' table in Postgres:**")

    st.data_editor(df)

if MONGODB_CONFIG_KEY in config_json and config_json[MONGODB_CONFIG_KEY] != "":
    mongodb_url = config_json[MONGODB_CONFIG_KEY]
    client = MongoClient(mongodb_url)

    db = client['demo_db']
    collection = db['demo_collection']

    st.write("**Contents of 'demo_collection' collection in MongoDB:**")

    cursor = collection.find({})
    for document in cursor:
          st.write(document)
