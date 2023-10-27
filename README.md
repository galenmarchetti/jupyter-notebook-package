# Jupyter Notebook + Database + Streamlit App

This is a free, local prototyping tool for Python developers crunching data and making visualizations. It connects Jupyter, a database of your choice, and Streamlit seamlessly for you, so you can use Jupyter to prototype your data gathering and Streamlit to prototype your data visualizations.

There are two main reasons to spin up Jupyter+DB+Streamlit this way:
- You automatically get pre-loaded PyMongo or SQLAlchemy clients in your Jupyter environment, with connection URLs correctly configured to your database. You also get the same in the Streamlit app.
- It's a one-line deploy from this Github locator (`github.com/galenmarchetti/jupyter-notebook-package`), so not much else to think about in order to get started

![jupyter-db-streamlit-15mb-shorter](https://github.com/galenmarchetti/jupyter-notebook-package/assets/11703004/11bf6f66-eb5e-4dff-a49a-9893c125c749)

Specifically, this is a [Kurtosis](https://github.com/kurtosis-tech/kurtosis) package that deploys:

- A [Jupyter notebook](https://jupyter-docker-stacks.readthedocs.io/en/latest/) with pre-loaded SqlAlchemy/PyMongo clients, hooked into
- A database (your choice of Postgres, MongoDB, or both)
- A basic [Streamlit](https://github.com/streamlit/streamlit) App with pre-loaded database clients, automatically connected to the databases you chose to deploy

The architecture of the system on your laptop, running over Docker, will look like:

![jupyter-database-package-diagram](https://github.com/galenmarchetti/jupyter-notebook-package/assets/11703004/d7e0e3f0-b8eb-4b90-b366-19ec8060b007)



To use this prototyping tool, you just need to [install Kurtosis](https://docs.kurtosis.com/install/) and its dependencies (listed in the install guide).

## Running the Environment

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

## Prototyping your Data App

### Crunching data in Jupyter

- Go to the "notebook" URL in the output to enter the Jupyter notebook.
  - The password by default is `kurtosis`.
  - Here you can mess around with pulling data from APIs, scraping websites, and putting the results into either Postgres or MongoDB.
  - You can use `!pip install <req>` in the notebook to install more Python packages.

<img width="708" alt="notebook-circled-output" src="https://github.com/galenmarchetti/jupyter-notebook-package/assets/11703004/437b0262-ac4e-41d0-87da-e06ba6d1a0f7">

### Viewing the Streamlit app frontend

- Go to the "app-frontend" URL in the output to see the Streamlit app frontend
  
![smaller-app-frontend-circled](https://github.com/galenmarchetti/jupyter-notebook-package/assets/11703004/80371936-0795-4f46-82c9-4b5fd9535ae4)

### Editing the Streamlit app

- To work on the Streamlit app, there's two ways to do it: your own IDE (slower iteration loop, but your own settings), or the pre-installed VSCode IDE (faster iteration loop, but a standard vanilla VSCode installation).
  - Pre-installed VSCode IDE: Click on the "vscode" URL in the output to open the VSCode IDE, which will modify your python files on disk.

![smaller-vs-code-interface-circled](https://github.com/galenmarchetti/jupyter-notebook-package/assets/11703004/762e4d09-95e1-45af-a104-b0f3ab17ef66)


  - Your own IDE: Clone this repository, `cd` into it, and instead of running `kurtosis run github.com/galenmarchetti/jupyter-notebook-package <ARGS>`, run the following:
    
```
kurtosis run .
```

Then, you can change your Python code using your IDE of choice, pointing it to `streamlit_app/` within this repository. Once you're done making your changes, you can re-run the above `kurtosis run .` command to create a new enclave with your changes loaded into the Streamlit service.

## Making Changes

You can make issues or submit PRs to this repository if you want to make changes, but I recommend you just fork it and take it where you want to take it. The repository defines a [Kurtosis](https://github.com/kurtosis-tech/kurtosis) package and you can go to the Kurtosis [docs](https://docs.kurtosis.com) for information on how to modify it to make it do what you need!
