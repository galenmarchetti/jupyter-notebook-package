# Jupyter Notebook + Postgres/MongoDB + Streamlit App

This is a free, local prototyping tool for Python developers crunching data and making visualizations, using Jupyter and Streamlit.

Specifically, this is a [Kurtosis](https://github.com/kurtosis-tech/kurtosis) package that deploys:
- A Jupyter notebook with pre-loaded SqlAlchemy/PyMongo clients, hooked into
- A database (your choice of Postgres, MongoDB, or both)
- A basic Streamlit App with pre-loaded database clients, automatically conencted to the databases you chose to deploy

To use this prototyping tool, you just need to [install Kurtosis](https://docs.kurtosis.com/install/) and its dependencies (listed in the install guide).

### Usage

1. Start with Postgres and MongoDB (default)
```
kurtosis run github.com/galenmarchetti/jupyter-notebook-package
```
2. Start with just Postgres
```
kurtosis run github.com/galenmarchetti/jupyter-notebook-package '{"mongodb_enabled": false}'
```
3. Start with just MongoDB
```
kurtosis run github.com/galenmarchetti/jupyter-notebook-package '{"postgres_enabled": false}'
```


