postgres = import_module("github.com/kurtosis-tech/postgres-package/main.star")
app_config_template = read_file("./config.json.tmpl")
startup_py_template = read_file("./startup.py.tmpl")

def run(plan):

    app_artifact = plan.upload_files(
		src='./streamlit_app'
	)

    ipython_config_artifact = plan.upload_files(
        src='notebook/ipython-config-directory'
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
            #files={
            #    "/home/jovyan/.ipython": ipython_config_artifact,
            #    "/home/jovyan/.ipython/profile_default/startup/": ipython_startup_artifact
            #},
            ports={
                "notebook": PortSpec(8888, application_protocol="http")
            },
            cmd=["jupyter", "notebook", "--no-browser","--NotebookApp.token=''","--NotebookApp.password=''"]
        )
    )

    # ADD STREAMLIT
    plan.add_service(
        name="streamlit-app",
        config=ServiceConfig(
            "python:3.11.5-bookworm",
			files={
				"/app": app_artifact,
                "/app/config": app_config_artifact
			},
			ports = {
				"app-frontend": PortSpec(
					8501,
					transport_protocol = "TCP",
					application_protocol = "http"
				)
			},
            cmd=
                ["/bin/sh",
                "-c",
                "cd /app; pip install -r requirements.txt; streamlit run streamlit_app.py"]
        )
    )