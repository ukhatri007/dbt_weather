with base as (

select
    claim_id,
    npi,
    is_denied,
    claim_amount
from {{ref('base_healthcare_data')}}
),
windowed as (
    
    select
        claim_id,
        npi,
        count(*) over (partition by npi) as npi_total_claims,
        sum(is_denied) over (partition by npi) as npi_total_denials,
        sum(claim_amount) over (partition by npi) as npi_total_claim_amount

    from base
 
),

except_one as (

select 
   w.claim_id,
   w.npi,
   (w.npi_total_claims - 1) as npi_volumn_except_one,
   
   -- calculation  deinal rate and average claim amount for each npi except the current claim
   case
        when (w.npi_total_claims - 1) > 0
        then (w.npi_total_denials - b.is_denied)/(w.npi_total_claims -1)
        else null
    end as npi_denial_rate_except_one,
    case
        when (w.npi_total_claims - 1) > 0 
        then (w.npi_total_claim_amount - b.claim_amount)/(w.npi_total_claims -1)
        else null
    end as npi_avg_claim_amount_except_one
from windowed w
join base b
on w.claim_id = b.claim_id),

-- overal average 
global_status as (
    select
        avg(is_denied) as global_denial_rate,
        avg(claim_amount) as global_avg_amount
    from base
),

final as (
    
    select
        e.claim_id,
        e.npi,
        e.npi_volumn_except_one,
        coalesce(e.npi_denial_rate_except_one, g.global_denial_rate) as npi_denial_rate,
        coalesce(e.npi_avg_claim_amount_except_one, g.global_avg_amount) as npi_avg_claim_amount
    from except_one e
    cross join global_status g

)

select * from final