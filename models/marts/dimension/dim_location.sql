

select 
    city_name,
    latitude,
    longitude,
    country_iso2,
    timezone_offset
from {{ref('base_weather_api_data')}}


