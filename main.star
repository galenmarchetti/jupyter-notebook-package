postgres = import_module("github.com/kurtosis-tech/postgres-package/main.star")
mongodb = import_module("github.com/kurtosis-tech/mongodb-package/main.star")
app_config_template = read_file("./config.json.tmpl")
startup_py_template = read_file("./startup.py.tmpl")

KURTOSIS_PASSWORD = 'kurtosis'

def run(plan, postgres_enabled=True, mongodb_enabled=True):

    app_artifact = plan.upload_files(
		src='./streamlit_app'
	)

    initial_notebook_artifact = plan.upload_files(
        src="./notebook.ipynb"
    )

    notebook_password = plan.upload_files(src="./notebook_password.json")

    # ADD DATABASES
    if (postgres_enabled):
        postgres_info = postgres.run(plan)
        postgres_url = postgres_info.url
    else:
        postgres_url = ""
    if (mongodb_enabled):
        mongodb_info = mongodb.run(plan)
        mongodb_url = mongodb_info.url
    else:
        mongodb_url = ""
    
    database_url_template_data = {
        "postgres_url": postgres_url,
        "mongodb_url": mongodb_url
    }

    app_config_artifact = plan.render_templates(
        config={
            "config.json": struct(
                template=app_config_template, data=database_url_template_data
            )
        }
    )

    ipython_startup_artifact = plan.render_templates(
        config={
            "startup.py": struct(
                template=startup_py_template, data=database_url_template_data
            )
        }
    )

    # ADD NOTEBOOK
    plan.add_service(
        name="notebook-server",
        config=ServiceConfig(
            "jupyter/datascience-notebook",
            files={
                "/ipython_profile_startup/": ipython_startup_artifact,
                "/home/jovyan/work": initial_notebook_artifact,
                "/tmp": notebook_password,
            },
            ports={
                "notebook": PortSpec(8888, application_protocol="http")
            },
            entrypoint=[
                "/bin/sh",
                "-c",
                "ipython profile create;" +
                "cp /ipython_profile_startup/startup.py /home/jovyan/.ipython/profile_default/startup/;" +
                "pip install psycopg2-binary;" +
                "mv /home/jovyan/work/notebook.ipynb /home/jovyan/;" +
                "mv /tmp/notebook_password.json /home/jovyan/.jupyter/jupyter_server_config.json;" +
                "jupyter notebook --no-browser --NotebookApp.token=''"]
        )
    )

    # ADD STREAMLIT
    streamlit_service = plan.add_service(
        name="streamlit-app",
        config=ServiceConfig(
            "h4ck3rk3y/streamlit",
			files={
				"/app": app_artifact,
                "/app/config": app_config_artifact
			},
			ports = {
				"app-frontend": PortSpec(
					8501,
					transport_protocol = "TCP",
					application_protocol = "http"
				),
                "vscode": PortSpec(
                    8080,
                    transport_protocol = "TCP",
                    application_protocol = "http",
                    wait = None,
                )
			},
            env_vars={
                "PASSWORD": KURTOSIS_PASSWORD
            },
            cmd=
                ["/bin/sh",
                "-c",
                "cd /app; streamlit run streamlit_app.py"]
        )
    )

    plan.exec(
        service_name=streamlit_service.name,
        recipe = ExecRecipe(
            command = ["/bin/sh", "-c", 'nohup code-server --bind-addr="0.0.0.0:8080" --welcome-text="Welcome To Kurtosis!" /app >/dev/null 2>&1 &']
        )
    )

    plan.print("Started VSCode & Jupyter with password {0}".format(KURTOSIS_PASSWORD))
