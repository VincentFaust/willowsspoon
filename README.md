# Project Overview

During the pandemic, my partner and I cofounded a small business specializing in crafting homemade, fresh dog cookies and jerky. Our passion for creating these treats stemmed from our own experiences making them for our pets. 

Our goal with the project was never to attempt to reach massive growth or scalability, but simply to build something from scratch and share one of our passions with other dog lovers. 

## Shopify ETL 

This project extracts data from the shopify API and loads it into snowflake. Once in the warehouse, the data is transformed into facts and dimensions with DBT and is visualized with Hex. Finally, airfllow calls these services in a dag on a fixed schedule. 

![sales_locations](images/sales_breakouts.png)



## Codebase

1. **Infrastructure-core**: Terraform code of cloud resources - ec2 instance (where Airbyte is hosted), snowflake(database, schema, warehouses and grants) and airbyte(code as configuration). These resources are responsible for the extract-load portion of the pipeline. 

2. **Transformation**: DBT to translate raw data into facts and dimensions for a business process (sales). I've input a logical separation between source, staging and serving into their own respective schemas. The end result in serving leaves downstream users with an atomic grain of sales data which is meant to act as a template for their use cases to build off. The DBT code is packaged up on a docker image and then run on AWS ECS. 

3. **Orchestration**: Airflow is run locally on a docker image and calls airbyte and dbt as tasks in a dag. My choice to run locally was driven solely by the expensive managed cloud offerings. 

4. **Github Actions**: An integration pipeline to automate python linting (pylint) and sql (sqlfluff, both syntax and tests). A unique feature build into the pipeline is the configuration for branch based deployments, which runs and tests only modified sql files in their own database.


## Architecture Diagram 

![ws_diagram](images/ws_diagram.png)


## Getting Started 

# Prerequisites

Before you begin, make sure you have the following:

1. An AWS account with appropriate permissions to create an EC2 instance and Snowflake resources.
2. Terraform installed on your local machine. 
3. Docker installed on your local machine. 
4. The AWS CLI installed on your local machine. 
5. After cloning the repo, run `pip install -r requirements.txt` in the project directory to get the necessary dependencies. 

# Building the Infrastructure

## AWS 
1. Clone the project repository to your local machine.

2. Navigate to the terraform directory in the cloned repository. Update the ssh config block with your own IP address or can opt to leave it open ```["0.0.0.0/0"]``` for maximum flexibility. 

3. Run terraform init to initialize the project.

4. Run terraform plan to see the changes that will be made to your infrastructure.

5. Run terraform apply to build the AWS EC2 instance. 

## Snowflake 

We need to create a separate user account from the main snowflake credentials so we can run terraform. 
1. Create an RSA key for Authentication 

```
cd ~/.ssh
openssl genrsa 2048 | openssl pkcs8 -topk8 -inform PEM -out snowflake_tf_snow_key.p8 -nocrypt
openssl rsa -in snowflake_tf_snow_key.p8 -pubout -out snowflake_tf_snow_key.pub
``` 

2. Copy the contents, starting after what followings PUBLIC KEY 

3. Paste the result from #2 into the config block below 

```
CREATE USER "tf-snow" RSA_PUBLIC_KEY='RSA_PUBLIC_KEY_HERE' DEFAULT_ROLE=PUBLIC MUST_CHANGE_PASSWORD=FALSE;
GRANT ROLE SYSADMIN TO USER "tf-snow";
GRANT ROLE SECURITYADMIN TO USER "tf-snow";
```

4. Then in a config file in your snowflake directory, run the below in a terminal session. Replace the brackets with your own snowflake account information. 

```
export SNOWFLAKE_USER="tf-snow"
export SNOWFLAKE_PRIVATE_KEY_PATH=/Users/fitz/.ssh/snowflake_tf_snow_key.p8
export SNOWFLAKE_ACCOUNT="{locator_name}"
export SNOWFLAKE_REGION="{region_name}"

```


## Hosting Airbyte on the EC2 Instance

1. Connect to the EC2 instance using SSH.

2. Install Docker on the EC2 instance, like so:

```
sudo yum update -y
sudo yum install -y docker
sudo service docker start
sudo usermod -a -G docker $USER
```

3. Install docker compose: 

```
sudo yum install -y docker-compose-plugin
docker compose version
```

4. Install Airbyte 

```
mkdir airbyte && cd airbyte
wget https://raw.githubusercontent.com/airbytehq/airbyte-platform/main/{.env,flags.yml,docker-compose.yaml}
docker compose up -d 
``` 

## Installing Octavia CLI 

1. Install Octavia to boostrap resources 

```
curl -s -o- https://raw.githubusercontent.com/airbytehq/airbyte/master/octavia-cli/install.sh | bash

```

2. Place Octavia enviornment files in your .bashrc
```
OCTAVIA_ENV_FILE=/home/ec2-user/.octavia
export OCTAVIA_ENABLE_TELEMETRY=True
alias octavia="docker run -i --rm -v \$(pwd):/home/octavia-project --network host --env-file \${OCTAVIA_ENV_FILE} --user \$(id -u):\$(id -g) airbyte/octavia-cli:0.40.18"
```

3. Configure your airbyte instance login credentials as secrets in the .octavia file 

```
OCTAVIA_ENABLE_TELEMETRY=True
AIRBYTE_USERNAME=airbyte
AIRBYTE_PASSWORD=password 
```

4. Create a separate directory to configure your source and destinations and then enter the following command 

```
octavia init
```

5. Now we need to find our custom definitions. For example: 

```
octavia list connectors sources | grep postgres 

octavia generate source decd338e-5647-4c0b-adf4-da0e75f5a750 postgres

```

This will generate the source for you. Replace all the config variables with your own account information and place secrets in your .octavia file. 

6. Congratulations! You will now see your source in the UI. 

7. Repeat above steps for destination. Just swap the word "sources" with "destination" 


# Setting up the dbt Project

1. Clone the dbt project to your local machine.

2. Install dbt on your local machine. For more information on how to install dbt, visit the official dbt website.

3. Configure the dbt project to use the Snowflake destination. 

4. Customize your profiles yml for your needs. 

5. Build and test the dbt project locally.

6. Push the dbt project to a git repository.

# Running Airflow Locally

1. Clone the Airflow project to your local machine.

2. Install Airflow on your local machine. 

3. Configure the Airflow project to call the Airbyte and dbt services.

4. Start the Airflow web server and scheduler.

5. Trigger the Airflow DAG to run both the Airbyte and dbt services.

