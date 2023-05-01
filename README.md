# Project Overview

During the pandemic, my partner and I cofounded a small business specializing in crafting homemade, fresh dog cookies and jerky. Our passion for creating these treats stemmed from our own experiences making them for our beloved pets. 

We knew this idea might not have the potential for massive growth or scalability, but our primary motivation was building something from scratch and sharing it with other dog lovers. 

## Shopify ETL 

This project extracts data from the shopify API and loads it into snowflake. Once in the warehouse, the data is transformed into facts and dimensions with DBT and is served into Hex. Finally, airfllow calls these services on a cron schedule. 

![sales_locations](images/sales_breakouts.png)



## Codebase

1. **Infrastructure-core**: Terraform code of cloud resources - ec2 instance (where Airbyte is hosted) and snowflake(database, schema, warehouses and grants). These resources are responsible for the extract-load portion of the pipeline. 

2. **Transformation**: DBT to translate raw data into facts and dimensions for a business process (sales). Input a logical separation between source, staging and serving into their own respective schemas. The end result in serving leaves downstream users with an atomic grain of sales data which is meant to act as a template for their use cases to build off. The DBT code is packaged up on a docker image and run on AWS ECS. 

3. **Orchestration**: Airflow is run locally on a docker image and calls airbyte and dbt as tasks in a dag. 




## Architecture Diagram 

![ws_diagram](images/ws_diagram.png)


## Getting Started 

# Prerequisites

Before you begin, make sure you have the following:

1. An AWS account with appropriate permissions to create an EC2 instance and Snowflake resources.
2. Terraform installed on your local machine. For more information on how to install Terraform, visit the official Terraform website.
3. Docker installed on your local machine. For more information on how to install Docker, visit the official Docker website.
4. The AWS CLI installed on your local machine. For more information on how to install the AWS CLI, visit the official AWS CLI website.
5. After cloning the repo, run `pip install -r requirements.txt` in the project directory to get the necessary dependencies. 

# Building the Infrastructure

1. Clone the project repository to your local machine.

2. Navigate to the terraform directory in the cloned repository.

3. Run terraform init to initialize the project.

4. Run terraform plan to see the changes that will be made to your infrastructure.

5. Run terraform apply to build the AWS EC2 instance and Snowflake resources.

# Hosting Airbyte on the EC2 Instance

1. Connect to the EC2 instance using SSH.

2. Install Docker on the EC2 instance.

3. Pull the Airbyte image from Docker Hub.

4. Run the Airbyte container on the EC2 instance.

5. Configure the Shopify source and Snowflake destination using the Airbyte web interface.

# Setting up the dbt Project

1. Clone the dbt project to your local machine.

2. Install dbt on your local machine. For more information on how to install dbt, visit the official dbt website.

3. Configure the dbt project to use the Snowflake destination.

4. Build and test the dbt project locally.

5. Push the dbt project to a git repository.

# Running Airflow Locally

1. Clone the Airflow project to your local machine.

2. Install Airflow on your local machine. For more information on how to install Airflow, visit the official Airflow website.

3. Configure the Airflow project to call the Airbyte and dbt services.

4. Start the Airflow web server and scheduler.

5. Trigger the Airflow DAG to run both the Airbyte and dbt services.

