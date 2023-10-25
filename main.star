postgres = import_module("github.com/kurtosis-tech/postgres-package/main.star")
app_config_template = read_file("./config.json.tmpl")

def run(plan):

    app_artifact = plan.upload_files(
		src='./streamlit_app',
	)

    # ADD DATABASE
    postgres_info = postgres.run(plan)
    template_data = {
        "postgres_url": postgres_info.url,
    }

    # ADD NOTEBOOK
    plan.add_service(
        name="notebook-server",
        config=ServiceConfig(
            "jupyter/datascience-notebook",
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