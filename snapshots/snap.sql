select 
    _created_at,
    unique_key,
    dbt_updated_at,
    datediff(day, _created_at,dbt_updated_at) as diff 
from weather_db.schema_weather_snapshots.base_weather_snapshots limit 20
