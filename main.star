postgres = import_module("github.com/kurtosis-tech/postgres-package/main.star")
app_config_template = read_file("./config.json.tmpl")
startup_py_template = read_file("./startup.py.tmpl")

def run(plan):

    app_artifact = plan.upload_files(
		src='./streamlit_app'
	)

    initial_notebook_artifact = plan.upload_files(
        src="./notebook.ipynb"
    )

    # ADD DATABASE
    postgres_info = postgres.run(plan)
    postgres_url_template_data = {
        "postgres_url": postgres_info.url,
    }

    app_config_artifact = plan.render_templates(
        config={
            "config.json": struct(
                template=app_config_template, data=postgres_url_template_data
            )
        }
    )

    ipython_startup_artifact = plan.render_templates(
        config={
            "startup.py": struct(
                template=startup_py_template, data=postgres_url_template_data
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
                "jupyter notebook --no-browser --NotebookApp.token='' --NotebookApp.password=''"]
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
            cmd=
                ["/bin/sh",
                "-c",
                "cd /app; streamlit run streamlit_app.py"]
        )
    )

    plan.exec(
        service_name=streamlit_service.name,
        recipe = ExecRecipe(
            command = ["/bin/sh", "-c", 'nohup code-server --bind-addr="0.0.0.0:8080" --auth=none --welcome-text="Welcome To Kurtosis!" /app >/dev/null 2>&1 &']
        )
    )
