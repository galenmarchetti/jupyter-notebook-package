postgres = import_module("github.com/kurtosis-tech/postgres-package/main.star")

def run(plan):
    # ADD DATABASE
    postgres_info = postgres.run(plan)
    postgress_connection_url = postgres_output.url

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
            "galenmarchetti/service-a",
            ports={
                "web-app": PortSpec(8501, application_protocol="http")
            }
        )
    )