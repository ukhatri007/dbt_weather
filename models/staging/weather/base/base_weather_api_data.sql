/*
Best practices to order final CTE

1. ids/keys/unique_keys
2. Dimensions
3. Boolean (dimensions)
3. Fact, metrices
4. Time/Date/Timestamps
5. Metadata

*/

with source as (
    select
        coord,
        weather,
        base,
        main,
        visibility,
        wind,
        clouds,
        dt,
        sys,
        timezone,
        id,
        name,
        cod,
        snow,
        rain,
        unique_key,
        _created_at
    from {{ source('weather_source', 'weather_api_data') }}
),

renamed as (

    select 
        coord:lat::double as latitude,
        coord:lon::double as longitude,
        weather[0]:description as description,
        weather[0]:main::string as weather_main,
        weather[0]:icon::string as weather_icon,
        base,
        main:feels_like::double as feels_like,
        main:temp::integer as temperature,
        main:grnd_level::integer as grnd_level,
        main:humidity::integer as humidity,
        main:pressure::integer as pressure,
        main:sea_level::integer as sea_level,
        main:temp_max::integer as temp_max,
        main:temp_min::integer as temp_min,
        visibility,
        wind:deg::float as wind_direction_deg,
        wind:gust::double as wind_gust,
        wind:speed::double as wind_speed,
        clouds,
        dt as _measured_at,
        sys:country::string as country_iso2,
        timezone as timezone_offset,
        id,
        name as city_name,
        cod,
        snow,
        rain,
        sys:sunrise::number as _sunrise_at,
        sys:sunset::number as _sunset_at,
        unique_key,
        _created_at
    from source

),

final as (

    select
        unique_key,
        id,
        
        city_name,
        latitude,
        longitude,
        weather_main,
        weather_icon,
        base,
        grnd_level,
        sea_level,
        clouds,
        country_iso2,
        cod,

        feels_like,
        pressure,
        temperature,
        humidity,
        temp_max,
        temp_min,
        visibility,
        wind_direction_deg,
        wind_gust,
        wind_speed,
        snow,
        rain,

        timezone_offset,
        _sunrise_at,
        _sunset_at,
        _measured_at,
        _created_at,

        description

    from renamed

)

select 
   * 
from final
