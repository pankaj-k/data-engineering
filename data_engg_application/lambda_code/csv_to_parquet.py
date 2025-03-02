import boto3
import awswrangler as wr
from urllib.parse import unquote_plus

tag_client = boto3.client('resourcegroupstaggingapi')

def lambda_handler(event, context):
    # Initialize the S3 client
    s3_client = boto3.client("s3")

    # Get the source bucket and object name as passed to the Lambda function
    for record in event["Records"]:
        bucket = record["s3"]["bucket"]["name"]
        key = unquote_plus(record["s3"]["object"]["key"])

    # We will set the DB and table name based on the last two elements of
    # the path prior to the filename. If key = 'dms/sakila/film/LOAD01.csv',
    # then the following lines will set db to 'sakila' and table_name to 'film'
    key_list = key.split("/")
    print(f"key_list: {key_list}")
    db_name = key_list[len(key_list) - 3]
    table_name = key_list[len(key_list) - 2]

    print(f"Bucket: {bucket}")
    print(f"Key: {key}")
    print(f"DB Name: {db_name}")
    print(f"Table Name: {table_name}")
    input_path = f"s3://{bucket}/{key}"
    print(f"Input_Path: {input_path}")

    # Do not Get list of all buckets in the account. Insecure and unnecessary
    # list_of_buckets = s3_client.list_buckets()

    # Find the bucket that starts with the base name and has the random suffix
    # Return is a list but we will only use the first element. There will be only one bucket with the given tag.
    output_bucket = (get_buckets_by_tag('Name', 'clean-zone'))[0]

    if not output_bucket:
        print("No matching bucket found")
        return
    else:
        print(f"Found matching bucket: {output_bucket}")
        output_path = f"s3://{output_bucket}/{db_name}/{table_name}"
        print(f"Output_Path: {output_path}")

    input_df = wr.s3.read_csv([input_path])
    current_databases = wr.catalog.databases()
    wr.catalog.databases()
    if db_name not in current_databases.values:
        print(f"- Database {db_name} does not exist ... creating")
        wr.catalog.create_database(db_name)
    else:
        print(f"- Database {db_name} already exists")

    result = wr.s3.to_parquet(
        df=input_df,
        path=output_path,
        dataset=True,
        database=db_name,
        table=table_name,
        mode="append",
    )
    print("RESULT: ")
    print(f"{result}")
    return result

def get_buckets_by_tag(key, value):
    response = tag_client.get_resources(
        TagFilters=[
            {
                'Key': key,
                'Values': [value]
            }
        ],
        ResourceTypeFilters=['s3']
    )
    
    # Extract bucket names
    buckets = [resource['ResourceARN'].split(':')[-1] for resource in response['ResourceTagMappingList']]
    return buckets