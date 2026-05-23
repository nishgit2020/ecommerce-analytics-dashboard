import pandas as pd

# Data cleaning

# products dataset

df = pd.read_csv('./data/products.csv')
# Fix missing category
df['product_category_name'] = df['product_category_name'].fillna('Unknown')
product_dim = ['product_weight_g','product_length_cm','product_height_cm','product_width_cm']
df[product_dim] = df[product_dim].fillna(0)
df.to_csv('./data/clean_products.csv',index=False)

# geolocation dataset

df = pd.read_csv('./data/geolocation.csv', encoding='latin1')
# Fix duplicate rows in table
df = df.drop_duplicates()
# Fix aggregation complexity
df = df.groupby('geolocation_zip_code_prefix').agg({
    'geolocation_lat' : 'mean',
    'geolocation_lng' : 'mean',
    'geolocation_city' : 'first',
    'geolocation_state' : 'first'
}).reset_index()
df.to_csv('./data/clean_geolocation.csv',index=False)

# order_payments dataset

df = pd.read_csv('./data/order_payments.csv')
# Fix aggregation complexity
df = df.groupby('order_id')['payment_value'].sum().reset_index()
df.rename(columns={'payment_value': 'total_payment'}, inplace=True)
df.to_csv('./data/clean_payments.csv', index=False)

# data merge
df_orders = pd.read_csv('./data/orders.csv')
df_customers = pd.read_csv('./data/customers.csv')
df_payments = pd.read_csv('./data/clean_payments.csv')
df_items = pd.read_csv('./data/order_items.csv')
df_products = pd.read_csv('./data/clean_products.csv')
df_sellers = pd.read_csv('./data/sellers.csv')
df_cat = pd.read_csv('./data/product_category_name_translation.csv')

order_customer_df = df_orders.merge(df_customers, on='customer_id',how='left')
order_customer_payment_df = order_customer_df.merge(df_payments, on='order_id',how='left')
order_customer_payment_items_df = order_customer_payment_df.merge(df_items, on='order_id',how='left')
order_customer_payment_items_products_df = order_customer_payment_items_df.merge(df_products, on='product_id',how='left')
order_customer_payment_items_products_seller_df = order_customer_payment_items_products_df.merge(df_sellers, on='seller_id',how='left')
df_final = order_customer_payment_items_products_seller_df.merge(df_cat, on='product_category_name', how='left')

# final dataset
df_final.to_csv('./data/final_dataset.csv', index=False)
print("------completed-------")

df_final = pd.read_csv('./data/final_dataset.csv')

# KPI 1: sum of total payments
total_payment = df_final.groupby('order_id')['total_payment'].first().sum()
print('₹',round(total_payment,2))

# KPI 2: count of orders
print(df_final['order_id'].nunique())

# KPI 3: unique custome count
print(df_final['customer_unique_id'].nunique())

# KPI 4: average order value
total_payment = round(df_final.groupby('order_id')['total_payment'].first().sum(),2)
total_order = df_final['order_id'].nunique()
aov = total_payment/total_order
print('₹',round(aov,2))

# monthly revenue trend
pdate = pd.to_datetime(df_final['order_purchase_timestamp'])
df_final['year_month'] = pdate.dt.strftime('%Y-%m')
df_monthly_revenue = pd.DataFrame(df_final.groupby(['year_month','order_id'])['total_payment'].first().reset_index())
df_monthly_revenue = df_monthly_revenue.groupby(['year_month'])['total_payment'].sum()
print(df_monthly_revenue)

# top product categories by revenue
df_top_product = df_final.groupby(['product_category_name_english'])['total_payment'].sum().sort_values(ascending=False).head(10)
print(df_top_product)

# top sales by customer state
df_top_sales = df_final.groupby(['order_id','customer_state'])['total_payment'].first().reset_index(name='total_sales')
df_top_sales = df_top_sales.groupby('customer_state')['total_sales'].sum().sort_values(ascending=False).head(10)
print(df_top_sales)

# top seller cities by revenue
df_top_seller = df_final.groupby(['order_id','seller_city'])['price'].sum().reset_index()
df_top_seller = df_top_seller.groupby('seller_city')['price'].sum().sort_values(ascending=False).head(10)
print(df_top_seller)

# order status
total_order = df_final['order_id'].nunique()
df_status = df_final[['order_status','order_id']].groupby(['order_status'])['order_id'].nunique().reset_index(name='orders')
df_status['percentage'] = round((df_status['orders']/total_order)*100,2)
print(df_status)
