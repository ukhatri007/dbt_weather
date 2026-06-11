select 
    main:feels_like::double as feels_like,
    main:grnd_level::integer as grnd_level,
    main:humidity::integer as humidity,
    main:pressure::integer as pressure,
    main:sea_level::integer as sea_level,
    main:temp::integer as temp,
    main:temp_max::integer as temp_max,
    main:temp_min::integer as temp_min
from {{source('weather_source', 'weather_api_data')}}
