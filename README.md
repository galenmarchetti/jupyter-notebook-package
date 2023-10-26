# Jupyter Notebook + Postgres/MongoDB + Streamlit App

This is a free, local prototyping tool for Python developers crunching data and making visualizations, using Jupyter and Streamlit.

Specifically, this is a [Kurtosis](https://github.com/kurtosis-tech/kurtosis) package that deploys:
- A Jupyter notebook with pre-loaded SqlAlchemy/PyMongo clients, hooked into
- A database (your choice of Postgres, MongoDB, or both)
- A basic Streamlit App with pre-loaded database clients, automatically conencted to the databases you chose to deploy

To use this prototyping tool, you just need to [install Kurtosis](https://docs.kurtosis.com/install/) and its dependencies (listed in the install guide).

### Running the Environment

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

### Prototyping your Data App

- Go to the "notebook" URL in the output to enter the Jupyter notebook.
  - The password by default is `kurtosis`.
  - Here you can mess around with pulling data from APIs, scraping websites, and putting the results into either Postgres or MongoDB.
  - You can use `!pip install <req>` in the notebook to install more Python packages.
<img width="708" alt="notebook-circled-output" src="https://github.com/galenmarchetti/jupyter-notebook-package/assets/11703004/437b0262-ac4e-41d0-87da-e06ba6d1a0f7">

- Go to the "app-frontend" URL in the output to see the Streamlit app frontend
<img width="708" alt="app-frontend-circled-output" src="https://github.com/galenmarchetti/jupyter-notebook-package/assets/11703004/4639abd8-b720-4ca6-9944-00de74b618f9">

- To work on the Streamlit app, there's two ways to do it: your own IDE (slower iteration loop, but your own settings), or the pre-installed VSCode IDE (faster iteration loop, but a standard vanilla VSCode installation).
  - Pre-installed VSCode IDE: Click on the "vscode" URL in the output to open the VSCode IDE, which will modify your python files on disk.
<img width="708" alt="vscode-circled-output" src="https://github.com/galenmarchetti/jupyter-notebook-package/assets/11703004/16b14830-3361-43d9-a5ca-72105e2aed75">

  - Your own IDE: Clone this repository, `cd` into it, and instead of running `kurtosis run github.com/galenmarchetti/jupyter-notebook-package <ARGS>`, run the following:
    
```
kurtosis run .
```

Then, you can change your Python code using your IDE of choice, pointing it to `streamlit_app/` within this repository. Once you're done making your changes, you can re-run 

```
kurtosis run .
```

And the Kurtosis package will run again with _your_ changed code, in a new enclave, and you'll be able to see your changes.



