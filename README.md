# Project Overview

During the pandemic, my partner and I cofounded on a small business specializing in crafting homemade, fresh dog cookies and jerky. Our passion for creating these treats stemmed from our own experiences making them for our beloved pets. 

We this idea might not have the potential for massive growth or scalability, but our primary motivation was building something from scratch and sharing other dog lovers. 

## Shopify ETL 

This project extracts data from the shopify API and loads it into snowflake. Once in the warehouse, the data is transformed into facts and dimensions with DBT and is served into Hex. Finally, airfllow calls these services on a cron schedule. 

![sales_locations](images/sales_breakouts.png)



## Overview

1. **Data Source**: Shopify API
2. **Data Extraction/Load**: Airbyte
3. **Data Warehouse**: Snowflake
4. **Data Transformation**: DBT

## Architecture Diagram 

![ws_diagram](images/ws_diagram.png)


