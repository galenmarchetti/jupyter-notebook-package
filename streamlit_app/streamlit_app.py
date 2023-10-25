import streamlit as st
import pandas as pd
from sqlalchemy import create_engine

engine = create_engine('postgresql://username:password@localhost:5432/mydatabase')

df = pd.read_sql_query('select * from "my_table"',con=engine)

st.write("Table: " + str(df))

st.write("Hello World!")
