import pendulum

from airflow import DAG
from airflow.providers.airbyte.operators.airbyte import AirbyteTriggerSyncOperator
from airflow.providers.amazon.aws.operators.ecs import EcsRunTaskOperator

with DAG(
        dag_id="willowsspoon_etl",
        schedule_interval=None, 
        start_date=pendulum.datetime(2020, 1, 1, tz="UTC"),
        catchup=False,
        tags=["extract-load"]
) as dag:

    airbyte_conn_id = "airbyte_vfaust"
    airbyte_pgsf_conn_id = "652b18e2-2a0c-419d-ae9f-e6c642752fe7"

    trigger_sync = AirbyteTriggerSyncOperator(
        task_id="trigger_sync", 
        airbyte_conn_id=airbyte_conn_id,
        connection_id=airbyte_pgsf_conn_id,
        asynchronous=False,
        timeout=3600,
        wait_seconds=3
    ) 

    transform_sync = EcsRunTaskOperator(
        task_id="transform_sync", 
        aws_conn_id="aws_vincentffaust",
        cluster="dbt-cluster-001", 
        launch_type="EC2", 
        task_definition="dbt-prod",
        region="us-east-2",
        overrides={}

    )

    trigger_sync >> transform_sync
