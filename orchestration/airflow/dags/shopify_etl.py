import pendulum

from airflow import DAG
from airflow.providers.airbyte.operators.airbyte import AirbyteTriggerSyncOperator
from airflow.providers.amazon.aws.operators.ecs import EcsRunTaskOperator

with DAG(
    dag_id="willowsspoon_etl",
    schedule_interval=None,
    start_date=pendulum.datetime(2020, 1, 1, tz="UTC"),
    catchup=False,
    tags=["extract-load"],
) as dag:
    AIRBYTE_CONN_ID = "airbyte_vfaust"
    AIRBYTE_PGSF_CONN_ID = "883544fb-7d49-4f0e-9a3b-a311cddf1be6"

    trigger_sync = AirbyteTriggerSyncOperator(
        task_id="trigger_sync",
        airbyte_conn_id=AIRBYTE_CONN_ID,
        connection_id=AIRBYTE_PGSF_CONN_ID,
        asynchronous=False,
        timeout=3600,
        wait_seconds=3,
    )

    transform_sync = EcsRunTaskOperator(
        task_id="transform_sync",
        aws_conn_id="aws_vincentffaust",
        cluster="dbt-cluster-001",
        launch_type="EC2",
        task_definition="dbt-prod",
        region="us-east-2",
        overrides={},
    )

    trigger_sync >> transform_sync
