import pendulum

from airflow import DAG
from airflow.providers.airbyte.operators.airbyte import AirbyteTriggerSyncOperator
from airflow.providers.amazon.aws.operators.ecs import EcsRunTaskOperator

with DAG(
    dag_id="willowsspoon_etl",
    schedule_interval="0 0 * * *",
    start_date=pendulum.datetime(2020, 1, 1, tz="UTC"),
    catchup=False,
    tags=["extract-load"],
) as dag:
    AIRBYTE_CONN_ID = "airbyte_conn_id"
    AIRBYTE_PGSF_CONN_ID = "df83fa46-07e1-475b-a702-55efb89b1d7f"
    AWS_CONN_ID = "aws_vincent"

    trigger_sync = AirbyteTriggerSyncOperator(
        task_id="trigger_sync",
        airbyte_conn_id=AIRBYTE_CONN_ID,
        connection_id=AIRBYTE_PGSF_CONN_ID,
        asynchronous=False,
        timeout=3600,
        wait_seconds=3,
    )

    run_ecs_task = EcsRunTaskOperator(
        task_id="run_dbt_task",
        task_definition="dbt_task",
        launch_type="FARGATE",
        cluster="dev-cluster",
        aws_conn_id=AWS_CONN_ID,
        overrides={},
        region="us-east-2",
        network_configuration={
            "awsvpcConfiguration": {
                "subnets": [
                    "subnet-027b7269c689871de",
                    "subnet-07f289cf933680ff5",
                    "subnet-00580de61e045ddc5",
                ],
                "securityGroups": ["sg-06901fcbc567121ed"],
            }
        },
    )

    trigger_sync >> run_ecs_task
