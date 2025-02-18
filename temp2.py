import psycopg2
import pandas as pd

# Step 1: Connect to the local PostgreSQL database
local_conn = psycopg2.connect("postgresql://scraperuser:password@localhost/scraperdb")  # Replace with your local credentials
local_cursor = local_conn.cursor()

# Step 2: Fetch data from the local database
local_cursor.execute("SELECT * FROM pincodes")  # Replace with your actual table name
local_data = local_cursor.fetchall()

# Step 3: Convert the fetched data into a pandas DataFrame
columns = [desc[0] for desc in local_cursor.description]  # Get the column names
df = pd.DataFrame(local_data, columns=columns)

# Step 4: Connect to the remote PostgreSQL database
remote_conn = psycopg2.connect("postgresql://scraberdb_user:EV2D5VDBzTsG79iG8FPdoUQtfDo32yVe@dpg-cukas2d6l47c73c9m420-a.oregon-postgres.render.com/scraberdb")  # Remote DB credentials
remote_cursor = remote_conn.cursor()

# Step 5: Insert data into the remote PostgreSQL database
# Here we will insert the data in a simple loop (you can modify it based on performance needs)
for index, row in df.iterrows():
    remote_cursor.execute("""
        INSERT INTO pincodes (column1, column2, column3)  # Replace with your actual columns
        VALUES (%s, %s, %s)  # Replace the number of placeholders as per your columns
    """, tuple(row))

# Step 6: Commit the transaction and close the connections
remote_conn.commit()
local_cursor.close()
local_conn.close()
remote_cursor.close()
remote_conn.close()

print("Data transfer completed successfully!")
